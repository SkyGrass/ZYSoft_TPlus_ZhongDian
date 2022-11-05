using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ufida.T.EAP.AppBase;
using Ufida.T.BAP.Web.Base;
using System.Web.UI.WebControls;
using Chanjet.ZYSoft.ZhongDian.Interface;
using Ufida.T.EAP.Aop;
using Ufida.T.EAP.DataStruct.Context;
using System.Web;
using Ufida.T.EAP.Dal;

namespace Chanjet.ZYSoft.ZhongDian.UIP
{
    public class ZhongDianPage : IAppHandler
    {
        GenericController controller;
        IZhongDian interfaceService;
        Label lblUserName;
        Label lbUserId;
        Label lbAccount;
        Label lbDataBase;
        public void AppEventHandler(object sender, AppEventArgs e)
        {
            controller = sender as GenericController;
            lblUserName = controller.GetViewControl("lblUserName") as Label;
            lbUserId = controller.GetViewControl("lbUserId") as Label;
            lbAccount = controller.GetViewControl("lbAccount") as Label;
            lbDataBase = controller.GetViewControl("lbDataBase") as Label;
            interfaceService = ServiceFactory.getService<IZhongDian>();
            Page_Load(sender, e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            UserInfo userInfo = HttpContext.Current.Session["UserInfo"] as UserInfo;
            lblUserName.Text += userInfo.PersonName;
            lbUserId.Text += userInfo.UserID;
            lbAccount.Text += userInfo.AccountID;
            lbDataBase.Text += userInfo.DataSource;
        }
    }
}
