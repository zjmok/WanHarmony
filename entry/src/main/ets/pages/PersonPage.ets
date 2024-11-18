import { UserService } from '../api/services/UserService';
import { SuperUserInfo } from '../data/UserInfo';
import { toast } from '../utils/ToastUtils';
import { log } from '../utils/LogUtils';

let service: UserService

PersistentStorage.persistProp<SuperUserInfo>("superUserInfo", null)

@Component
export struct PersonComponent {
  pathStack: NavPathStack | null = null
  @StorageLink('superUserInfo') superUserInfo: SuperUserInfo | null = null;

  aboutToAppear(): void {
    service = new UserService();
    this.getUserInfo()
  }

  build() {
    Scroll() {
      Column() {
        Flex({ alignItems: ItemAlign.Center }) {
          Image(this.superUserInfo?.userInfo.icon ? this.superUserInfo?.userInfo.icon : $r("app.media.app_icon"))
            .borderRadius(10)
            .width(80)
            .aspectRatio(1)// 1:1
            .flexShrink(3)

          Column() {
            Text(this.superUserInfo?.userInfo.nickname ? this.superUserInfo?.userInfo.nickname : "未登录")

            Flex({ wrap: FlexWrap.Wrap }) {
              Text(`用户名：${this.superUserInfo?.userInfo.username ? this.superUserInfo?.userInfo.username : "null"}`)
                .fontSize(14)
                .fontColor($r("app.color.secondaryText"))
                .margin({ right: 20, top: 10 })
              Text(`ID：${this.superUserInfo?.userInfo.id ? this.superUserInfo?.userInfo.id : "-1"}`)
                .fontSize(14)
                .fontColor($r("app.color.secondaryText"))
                .margin({ top: 10 })
            }
            .margin({ top: 10 })

            Text(`邮箱：${this.superUserInfo?.userInfo.email ? this.superUserInfo?.userInfo.email : "null"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ top: 20 })
          }
          .padding({ left: 10, right: 10 })
          .flexBasis('auto')
          .width("60%")
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1) // 撑满剩余宽度

          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .aspectRatio(1)
        }
        .width("100%")
        .backgroundColor(Color.White)
        .padding({
          left: 16,
          right: 16,
          top: 40,
          bottom: 30,
        })
        .onClick(() => {
          if (!this.superUserInfo) {
            AlertDialog.show(
              {
                title: '提示',
                message: "请先登录！",
                autoCancel: true, // 点击外部取消
                alignment: DialogAlignment.Center,
                gridCount: 3, // 可控制弹窗宽度
                primaryButton: {
                  value: '取消',
                  fontColor: Color.Gray,
                  action: () => {

                  }
                },
                secondaryButton: {
                  value: '确定',
                  action: () => {
                    this.pathStack?.pushPathByName("LoginPage", "", (popInfo) => {
                      const result = popInfo.result as Record<string, string>
                      if (result) {
                        log(`<<<<<<${result.result}`)
                        // 登录接口返回的数据不全 后续获取完整数据
                        this.getUserInfo()
                      }
                    })
                    log("跳转 LoginPage")
                  }
                }
              }
            )

          } else {

          }
        })

        Row() {
          Text("积分排行")
            .fontSize(16)
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.End }) {
            Text(`积分：${this.superUserInfo?.coinInfo?.coinCount ? this.superUserInfo?.coinInfo?.coinCount : "-1"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ left: 10 })
            Text(`排行：${this.superUserInfo?.coinInfo?.rank ? this.superUserInfo?.coinInfo?.rank : "-1"}`)
              .fontSize(14)
              .fontColor($r("app.color.secondaryText"))
              .margin({ left: 10 })
          }
          .layoutWeight(1)

          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 10 })
        .padding(16)
        .onClick(() => {
          toast("开发中")
        })

        Row() {
          Text("收藏文章")
          Blank()
          Text(`收藏量：${this.superUserInfo?.collectArticleInfo?.count ?
            this.superUserInfo?.collectArticleInfo?.count : "-1"} 篇`)
            .fontSize(14)
            .fontColor($r("app.color.secondaryText"))
            .margin({ left: 10 })
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 10 })
        .padding(16)
        .onClick(() => {
          toast("开发中")
        })

        Row() {
          Text("分享文章")
          Blank()
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 1 })
        .padding(16)
        .onClick(() => {
          toast("开发中")
        })

        Row() {
          Text("收藏网站")
          Blank()
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 1 })
        .padding(16)
        .onClick(() => {
          toast("开发中")
        })

        Row() {
          Text("浏览历史")
          Blank()
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 1 })
        .padding(16)
        .onClick(() => {
          this.pathStack?.pushPathByName("HistoryPage", "", (popInfo) => {
            const result = popInfo.result as Record<string, string>
            if (result) {
              log(`<<<<<<${result.result}`)
            }
          })
          log("跳转 HistoryPage")
        })

        Row() {
          Text("设置")
          Blank()
          Image($r("app.media.icon_arrow_right"))
            .width(20)
            .height(20)
            .margin({ left: 5 })
        }
        .width("100%")
        .height("10%")
        .backgroundColor(Color.White)
        .margin({ top: 10, bottom: 100 })
        .padding(16)
        .onClick(() => {
          this.pathStack?.pushPathByName("SettingsPage", "", (popInfo) => {
            const result = popInfo.result as Record<string, string>
            if (result) {
              log(`<<<<<<${result.result}`)
            }
          })
          log("跳转 SettingsPage")
        })

      }
      .width("100%")
    }
    .backgroundColor(0xE5E5E5)
    // .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
    .scrollBar(BarState.Off) // 滚动条常驻显示
    // .scrollBarColor(Color.Gray) // 滚动条颜色
    // .scrollBarWidth(10) // 滚动条宽度
    .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
  }

  getUserInfo() {
    service.getUserInfo().then(result => {
      this.superUserInfo = result
      console.log(`PersonPage：result = ${result}`);
    }).catch((err: Error) => {
      console.error(`PersonPage：err = ${err}`);
    })
  }
}