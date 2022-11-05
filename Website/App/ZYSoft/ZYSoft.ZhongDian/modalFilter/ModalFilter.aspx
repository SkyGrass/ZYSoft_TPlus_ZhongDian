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
        <link href="./dialogFilter.css" rel="stylesheet" />
        <link href="../css/noborder.css" rel="stylesheet" />
    </head>

    <body>
        <div id="app" style="padding: 10px">
            <el-row v-if="fromTab1">
                <el-col :push="1" :span="20" :pull="1">
                    <el-form ref="form" :model="form" label-width="100px" size="mini" inline>
                        <table>
                            <tr>
                                <td>
                                    <el-form-item label="开始日期" class="form-item-max" prop='startDate'>
                                        <el-date-picker type="date" clearable style="width:100%"
                                            v-model="form.startDate" placeholder="请选择进货开始日期" class="noBorder">
                                        </el-date-picker>
                                    </el-form-item>
                                </td>
                                <td>
                                    <el-form-item label="结束日期" class="form-item-max" prop='endDate'>
                                        <el-date-picker type="date" clearable style="width:100%" v-model="form.endDate"
                                            placeholder="请选择进货结束日期" class="noBorder"></el-date-picker>
                                    </el-form-item>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <el-form-item label="进货单号" class="form-item-max" prop='orderNo'>
                                        <el-input clearable style="width:100%" v-model="form.orderNo"
                                            placeholder="请输入进货单号" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                                <td>
                                    <el-form-item label="存货" class="form-item-max" prop='inv'>
                                        <el-input clearable style="width:100%" v-model="form.inv"
                                            placeholder="请输入存货编码或名称" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <el-form-item label="规格" class="form-item-max" prop='invStd'>
                                        <el-input clearable style="width:100%" v-model="form.invStd" placeholder="请输入规格"
                                            class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <el-form-item label="供应商" class="form-item-max" prop='partner'>
                                        <el-input clearable style="width:100%" v-model="form.partner"
                                            placeholder="请输入供应商编码或名称" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                        </table>
                    </el-form>
                </el-col>
            </el-row>
            <el-row v-if="fromTab2">
                <el-col :push="1" :span="20" :pull="1">
                    <el-form ref="form" :model="form" label-width="100px" size="mini" inline>
                        <table>
                            <tr>
                                <td>
                                    <el-form-item label="开始日期" class="form-item-max" prop='startDate'>
                                        <el-date-picker type="date" clearable style="width:100%"
                                            v-model="form.startDate" placeholder="请选择开始日期" class="noBorder">
                                        </el-date-picker>
                                    </el-form-item>
                                </td>
                                <td>
                                    <el-form-item label="结束日期" class="form-item-max" prop='endDate'>
                                        <el-date-picker type="date" clearable style="width:100%" v-model="form.endDate"
                                            placeholder="请选择结束日期" class="noBorder"></el-date-picker>
                                    </el-form-item>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <el-form-item label="供应商" class="form-item-max" prop='partner'>
                                        <el-input clearable style="width:100%" v-model="form.partner"
                                            placeholder="请输入供应商编码或名称" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                                <td>
                                    <el-form-item label="存货" class="form-item-max" prop='inv'>
                                        <el-input clearable style="width:100%" v-model="form.inv"
                                            placeholder="请输入存货编码或名称" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <el-form-item label="规格" class="form-item-max" prop='invStd'>
                                        <el-input clearable style="width:100%" v-model="form.invStd" placeholder="请输入规格"
                                            class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                                <td>
                                    <el-form-item label="批号" class="form-item-max" prop='batchNo'>
                                        <el-input clearable style="width:100%" v-model="form.batchNo"
                                            placeholder="请输入批号" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <el-form-item label="条码" class="form-item-max" prop='barcode'>
                                        <el-input clearable style="width:100%" v-model="form.barcode"
                                            placeholder="请输入条码" class="noBorder">
                                        </el-input>
                                    </el-form-item>
                                </td>
                            </tr>
                        </table>
                    </el-form>
                </el-col>
            </el-row>
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
        <script src="./dialogFilter.js"></script>
        <script src="../js/math/math.min.js"></script>
    </body>

    </html>