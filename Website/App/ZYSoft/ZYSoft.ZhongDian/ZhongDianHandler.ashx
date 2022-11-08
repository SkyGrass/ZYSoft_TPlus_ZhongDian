<%@ WebHandler Language="C#" Class="ZhongDianHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Xml;
using System.Net;
using System.IO;
public class ZhongDianHandler : IHttpHandler
{
    public class Result
    {
        public string state { get; set; }
        public object data { get; set; }
        public string msg { get; set; }
    }

    public void ProcessRequest(HttpContext context)
    {
        ZYSoft.DB.Common.Configuration.ConnectionString = DBMethods.LoadXML("ConnectionString");
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["SelectApi"] != null)
        {
            string result = "";
            switch (context.Request.Form["SelectApi"].ToLower())
            {
                case "getconnect":
                    result = ZYSoft.DB.Common.Configuration.ConnectionString;
                    break;
                case "getlist1":
                    string inv = context.Request.Form["inv"] ?? "";
                    string orderNo = context.Request.Form["orderNo"] ?? "";
                    string partner = context.Request.Form["partner"] ?? "";
                    string invStd = context.Request.Form["invStd"] ?? "";
                    string startDate = context.Request.Form["startDate"] ?? "";
                    string endDate = context.Request.Form["endDate"] ?? "";
                    string accId = context.Request.Form["accId"] ?? "";
                    result = DBMethods.GetList1(inv, orderNo, partner, startDate, endDate, invStd, accId);
                    break;
                case "getlist2":
                    startDate = context.Request.Form["startDate"] ?? "";
                    endDate = context.Request.Form["endDate"] ?? "";
                    inv = context.Request.Form["inv"] ?? "";
                    partner = context.Request.Form["partner"] ?? "";
                    invStd = context.Request.Form["invStd"] ?? "";
                    string batchNo = context.Request.Form["batchNo"] ?? "";
                    string barcode = context.Request.Form["barcode"] ?? "";
                    accId = context.Request.Form["accId"] ?? "";
                    result = DBMethods.GetList2(inv, partner, batchNo, barcode, startDate, endDate, invStd, accId);
                    break;
                case "getlist3":
                    inv = context.Request.Form["inv"] ?? "";
                    string whName = context.Request.Form["whName"] ?? "";
                    string posName = context.Request.Form["posName"] ?? "";
                    batchNo = context.Request.Form["batchNo"] ?? "";
                    accId = context.Request.Form["accId"] ?? "";
                    result = DBMethods.GetList3(inv, whName, posName, batchNo, accId);
                    break;
                case "getbase":
                    result = DBMethods.GetBaseData();
                    break;
                case "gettemplete":
                    result = DBMethods.GetPrintTemplete();
                    break;
                default: break;
            }
            context.Response.Write(result);
        }
        else
        {
            context.Response.Write("服务正在运行!");
        }
    }

    public class DBMethods
    {
        #region 查询数据源1
        public static string GetList1(string inv, string orderNo, string partner, string startDate,
         string endDate, string invStd, string accId)
        {
            if (string.IsNullOrEmpty(accId))
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = "没有获取到账套信息!"
                });
            }
            var list = new List<Result>();
            try
            {
                string sqlWhere = " 1=1 ";
                if (!string.IsNullOrEmpty(inv))
                {
                    sqlWhere += string.Format(" AND ( cInvName like ''%{0}%'' or cInvCode like ''%{0}%'' )", inv);
                }
                if (!string.IsNullOrEmpty(orderNo))
                {
                    sqlWhere += string.Format(@" AND  code like ''%{0}%''", orderNo);
                }
                if (!string.IsNullOrEmpty(partner))
                {
                    sqlWhere += string.Format(@" AND  cVenName like ''%{0}%''", partner);
                }
                if (!string.IsNullOrEmpty(invStd))
                {
                    sqlWhere += string.Format(@" AND  cInvStd like ''%{0}%''", invStd);
                }
                if (!string.IsNullOrEmpty(startDate))
                {
                    sqlWhere += string.Format(@" AND  VoucherDate >= ''{0} 00:00:00''", startDate);
                }
                if (!string.IsNullOrEmpty(endDate))
                {
                    sqlWhere += string.Format(@" AND  VoucherDate <= ''{0} 23:59:59''", endDate);
                }

                string sql =
                        string.Format(@"EXEC ZYSoft_ZDXN_2021.DBO.P_GetLabPrintData 
                                    @FAccountNo = '{0}',
                                    @FType = 1,
                                    @FFilter = '{1}'",
                          accId, sqlWhere);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询数据源2
        public static string GetList2(string inv, string partner, string batchNo, string barcode, string startDate, string endDate, string invStd, string accId)
        {
            if (string.IsNullOrEmpty(accId))
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = "没有获取到账套信息!"
                });
            }
            var list = new List<Result>();
            try
            {
                string sqlWhere = " 1=1 ";
                if (!string.IsNullOrEmpty(startDate))
                {
                    sqlWhere += string.Format(@" AND  FDate >= ''{0} 00:00:00''", startDate);
                }
                if (!string.IsNullOrEmpty(endDate))
                {
                    sqlWhere += string.Format(@" AND  FDate <= ''{0} 23:59:59''", endDate);
                }
                if (!string.IsNullOrEmpty(inv))
                {
                    sqlWhere += string.Format(" AND ( FInvName like ''%{0}%'' or FInvCode like ''%{0}%'' )", inv);
                }

                if (!string.IsNullOrEmpty(partner))
                {
                    sqlWhere += string.Format(@" AND  FVenName like ''%{0}%''", partner);
                }

                if (!string.IsNullOrEmpty(invStd))
                {
                    sqlWhere += string.Format(@" AND  FInvStd like ''%{0}%''", invStd);
                }

                if (!string.IsNullOrEmpty(batchNo))
                {
                    sqlWhere += string.Format(@" AND  FBatch like ''%{0}%''", batchNo);
                }

                if (!string.IsNullOrEmpty(barcode))
                {
                    sqlWhere += string.Format(@" AND  FBarcode like ''%{0}%''", barcode);
                }


                string sql =
                        string.Format(@"EXEC ZYSoft_ZDXN_2021.DBO.P_GetLabPrintData 
                                    @FAccountNo = '{0}',
                                    @FType = 2,
                                    @FFilter = '{1}'",
                          accId, sqlWhere);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询数据源3
        public static string GetList3(string inv, string whName, string posName, string batchNo, string accId)
        {
            if (string.IsNullOrEmpty(accId))
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = "没有获取到账套信息!"
                });
            }
            var list = new List<Result>();
            try
            {
                string sqlWhere = " 1=1 ";
                if (!string.IsNullOrEmpty(inv))
                {
                    sqlWhere += string.Format(" AND ( cInvName like ''%{0}%'' or cInvCode like ''%{0}%'' )", inv);
                }
                if (!string.IsNullOrEmpty(whName))
                {
                    sqlWhere += string.Format(@" AND ( cWhName like ''%{0}%'' or cWhCode like ''%{0}%'' )", whName);
                }
                if (!string.IsNullOrEmpty(posName))
                {
                  sqlWhere += string.Format(@" AND ( cPosName like ''%{0}%'' or cPosCode like ''%{0}%'' )", posName);
                }
                if (!string.IsNullOrEmpty(batchNo))
                {
                    sqlWhere += string.Format(@" AND  cBatch like ''%{0}%''", batchNo);
                } 

                string sql =
                        string.Format(@"EXEC ZYSoft_ZDXN_2021.DBO.P_GetLabPrintData 
                                    @FAccountNo = '{0}',
                                    @FType = 3,
                                    @FFilter = '{1}'",
                          accId, sqlWhere);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion


        #region 查询固化条件
        public static string GetBaseData()
        {
            var list = new List<Result>();
            try
            {
                string sql = string.Format(@"select * from  ZYSoft_JSHG_2022.dbo.t_BaseData");
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询打印模板
        public static string GetPrintTemplete()
        {
            var list = new List<Result>();
            try
            {
                string sql = string.Format(@"select FTranType,FTitle from ZYSoft_JSHG_2022.dbo.t_Report");
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        public static void AddLogErr(string SPName, string ErrDescribe)
        {
            string tracingFile = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, "ZYSoftLog");
            if (!Directory.Exists(tracingFile))
                Directory.CreateDirectory(tracingFile);
            string fileName = DateTime.Now.ToString("yyyyMMdd") + ".txt";
            tracingFile += fileName;
            if (tracingFile != string.Empty)
            {
                FileInfo file = new FileInfo(tracingFile);
                StreamWriter debugWriter = new StreamWriter(file.Open(FileMode.Append, FileAccess.Write, FileShare.ReadWrite));
                debugWriter.WriteLine(SPName + " (" + DateTime.Now.ToString() + ") " + " :");
                debugWriter.WriteLine(ErrDescribe);
                debugWriter.WriteLine();
                debugWriter.Flush();
                debugWriter.Close();
            }
        }

        #region 读取配置
        public static string LoadJSON(string key)
        {
            string filename = HttpContext.Current.Request.PhysicalApplicationPath + @"zddialogconf.json";
            if (File.Exists(filename))
            {
                using (StreamReader sr = new StreamReader(filename, encoding: System.Text.Encoding.UTF8))
                {
                    JsonTextReader reader = new JsonTextReader(sr);
                    JObject jo = (JObject)JToken.ReadFrom(reader);
                    return JsonConvert.SerializeObject(new
                    {
                        state = jo[key] == null ? "error" : "success",
                        msg = jo[key] == null ? "未能查询到配置" : "成功",
                        data = jo[key]
                    });
                }
            }
            else
            {
                return "";
            }
        }
        #endregion

        public static string LoadXML(string key)
        {
            string filename = HttpContext.Current.Request.PhysicalApplicationPath + @"zysoftjszdweb.config";
            XmlDocument xmldoc = new XmlDocument();
            xmldoc.Load(filename);
            XmlNode node = xmldoc.SelectSingleNode("/configuration/appSettings");

            string return_value = string.Empty;
            foreach (XmlElement el in node)//读元素值 
            {
                if (el.Attributes["key"].Value.ToLower().Equals(key.ToLower()))
                {
                    return_value = el.Attributes["value"].Value;
                    break;
                }
            }

            return return_value;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}