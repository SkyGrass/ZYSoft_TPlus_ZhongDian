<%@ Page Language="C#" AutoEventWireup="true" %>

    <!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <link rel="stylesheet" href="../css/element-ui-index.css" />
        <link rel="stylesheet" href="../css/theme-chalk-index.css" />
        <link href="../js/layui/css/layui.css" rel="stylesheet" />
        <link href="../css/tabulator.min.css" rel="stylesheet" />
        <link href="./dialogTab4.css" rel="stylesheet" />
        <link href="../css/noborder.css" rel="stylesheet" />
    </head>

    <body>
        <div id="app" style="padding: 10px">
            <div>合计:<strong :style="{color:curSum>form.iQuantity?'red':'#333'}">{{curSum}}</strong></div>
            <table style="text-align: center;">
                <thead>
                    <td style="width: 40px;">#</td>
                    <td style="width: 250px;">包装数量</td>
                    <td style="width: 250px;">份数</td>
                </thead>
                <tbody>
                    <tr v-for="(item,index) in packQtyList">
                        <td>{{index+1}}</td>
                        <td>
                            <el-input-number style=" width: 90%;" placeholder="请输入包装数量" size="mini" v-model="item.qty"
                                :min="0" :controls="false" :precision="2" @blur="changeNum(item,index)">
                            </el-input-number>
                        </td>
                        <td><el-input-number style=" width: 100%;" placeholder="请输入份数" size="mini" v-model="item.copy"
                                :min="0" :controls="false" :precision="0">
                            </el-input-number>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <script src="../js/poly/js.polyfills.js"></script>
        <script src="../js/poly/es5.polyfills.js"></script>
        <script src="../js/poly/proxy.min.js"></script>
        <!-- import Vue before Element -->
        <script src="../js/jquery.min.js"></script>
        <script src="../js/vue.js"></script>
        <script src="../js/element-ui-index.js"></script>
        <script src="../js/tabulator.js"></script>
        <script src="../js/layui/layui.js"></script>
        <script src="../js/dayjs.min.js"></script>
        <script src="./dialogTab4.js"></script>
        <script src="../js/math/math.min.js"></script>
    </body>

    </html>