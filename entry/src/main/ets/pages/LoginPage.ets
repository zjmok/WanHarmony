import { SuperUserInfo } from '../data/UserInfo';
import { UserService } from '../api/services/UserService';
import { ApiException } from '../api/ApiException';
import { toast } from '../utils/ToastUtils';

let service: UserService

@Builder
export function LoginPageBuilder(name: string, param: string) {
  LoginPage()
}

PersistentStorage.persistProp<SuperUserInfo>("superUserInfo", null)

@Component
export struct LoginPage {
  @StorageLink('superUserInfo') superUserInfo: SuperUserInfo | null = null;
  pathStack: NavPathStack = new NavPathStack()
  private username: string = ''
  private password: string = ''

  aboutToAppear(): void {
    service = new UserService();
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text('登录')
          .fontSize(30)
          .fontWeight('bold')

        TextInput({
          placeholder: '请输入用户名',
          text: this.username,
        })
          .type(InputType.USER_NAME)
          .onChange((value: string) => {
            this.username = value
          })
          .padding({ top: 10, bottom: 10 })
          .borderRadius(10)
          .backgroundColor('#F5F5F5')

        TextInput({
          placeholder: '请输入密码',
          text: this.password,
        })
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value
          })
          .padding({ top: 10, bottom: 10 })
          .borderRadius(10)
          .backgroundColor('#F5F5F5')

        Button('登录')
          .onClick(() => {
            this.login()
          })
          .fontSize(20)
          .backgroundColor($r("app.color.color_fore"))
          .borderRadius(10)
          .width('100%')
          .height(50)
      }
      .padding(20)
    }
    .backgroundColor(0xE5E5E5)
    .title("登录")
    .hideTitleBar(false)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }

  login() {
    service.login(
      this.username,
      this.password
    ).then(result => {
      // 登录接口返回的数据不全 后续获取完整数据
      this.superUserInfo = new SuperUserInfo()
      this.superUserInfo.userInfo = result!
      this.pathStack.pop({ result: "我是从 LoginPage 返回的数据" })
    }).catch((err: Error) => {
      if (err instanceof ApiException) {
        toast("登录失败")
      } else {
        toast("登录失败")
      }
      console.error(`LoginPage：err = ${err}`);
    })
  }
}