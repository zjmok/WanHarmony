import { http } from '@kit.NetworkKit';
import { ApiException } from './ApiException';
import { ApiResult } from './ApiResult';
import { ApiPath } from './ApiPath';
import { TextUtils } from '../utils/TextUtils';
import { CookiesUtils } from './CookiesUtils';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON } from '@kit.ArkTS';

type HttpMethod = 'get' | 'post' | 'put' | 'delete'

class ApiService {
  // 上传文件需要另外处理 contentType 等
  async request<T>(
    httpMethod: HttpMethod,
    path: string,
    paramsMap: Map<string, string> | null = null,
    // headers: Record<string, string> = {},
    headers: Map<string, string> = new Map(),
    baseUrl: string = ApiPath.BASE_URL
  ): Promise<T> {

    return new Promise<T>((resolve, reject) => {

      // 处理 httpMethod
      let method: http.RequestMethod
      if (httpMethod == 'get') {
        method = http.RequestMethod.GET
      } else if (httpMethod == 'post') {
        method = http.RequestMethod.POST
      } else if (httpMethod == 'put') {
        method = http.RequestMethod.PUT
      } else if (httpMethod == 'delete') {
        method = http.RequestMethod.DELETE
      } else {
        throw new ApiException(-999, '你又在写 bug 了')
      }

      // 处理 baseUrl + path
      let url = baseUrl + path

      // 处理 paramsMap
      let params = ''
      if (paramsMap?.size) {
        if (httpMethod == 'get') {
          // 有参 get
          let queryParams = TextUtils.mapToUrlEncodedString(paramsMap)
          if (url.includes('?')) {
            url += '&' + queryParams
          } else {
            url += '?' + queryParams
          }
          hilog.info(0, "network", `${httpMethod}: ${url}`)
        } else {
          // 有参 非get
          // 键值对参数 和 contentType
          params = TextUtils.mapToUrlEncodedString(paramsMap)
          headers.set('Content-Type', 'application/x-www-form-urlencoded')
          hilog.info(0, "network", `${httpMethod}: ${url}`)
          hilog.info(0, "network", `parameters: ${params}`)
        }
      } else {
        // 无参
        hilog.info(0, "network", `${httpMethod}: ${url}`)
      }

      // cookies get
      PersistentStorage.persistProp<string>("cookies", "")
      let cookies = AppStorage.get<string>("cookies") // cookies get
      if (cookies) {
        // headers['Cookie'] = cookies
        headers.set('Cookie', cookies)
      }
      // 打印 headers
      let headersString = Array.from(headers.entries()).map((kv) => {
        return `${kv[0]}: ${kv[1]}`
      }).join(', ')
      hilog.info(0, "network", `headers: {${headersString}}`)

      // request
      let httpRequest = http.createHttp()
      httpRequest.request(
        url,
        {
          method: method,
          header: headers,
          // @type { ?(string | Object | ArrayBuffer) }
          // string 键值对
          // Object 如 Record<string, string> Map<string, string>
          // ArrayBuffer 上传文件
          extraData: params,
          // 上传文件
          // multiFormDataList:
        },
        (err, data) => {
          if (!err && data) {
            if (data.responseCode >= 200 && data.responseCode < 300) {
              hilog.info(0, "network", `(${data.responseCode}) response: ${data.result}`)
              // response code 2xx
              // response cookies
              if (data.cookies) {
                // 当 cookies 有值时才进行保存
                // hilog.info(0, "network", `data.cookies = ${data.cookies}`)
                let cookies = CookiesUtils.formatCookies(data.cookies)
                AppStorage.setOrCreate("cookies", cookies) // cookies save
                hilog.info(0, "network", `response cookies: ${cookies}`)
              }
              // response body
              let obj: ApiResult<T> = JSON.parse(data.result.toString()) as ApiResult<T>
              if (obj.errorCode == 0) {
                // 接口正常返回
                resolve(obj.data!)
              } else {
                // 接口 errorCode != 0
                let apiErr = new ApiException(obj.errorCode, obj.errorMsg)
                hilog.error(0, "network", `err = (${apiErr.errorCode}) ${apiErr.message}`)
                reject(apiErr)
              }
            } else {
              // response code 非 2xx
              hilog.error(0, "network", `responseCode = ${data.responseCode}\n${data.result}`)
              let apiErr = new ApiException(data.responseCode, "网络错误")
              reject(apiErr)
            }
          } else {
            // error
            hilog.error(0, "network", `err = (${err.code}) ${err.message}`)
            reject(err)
          }
          httpRequest.destroy()
        })
    })
  }
}

export default ApiService
