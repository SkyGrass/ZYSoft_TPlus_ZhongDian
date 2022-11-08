<%@ Page Language="C#" AutoEventWireup="true" %>
	<!DOCTYPE html>

	<html xmlns="http://www.w3.org/1999/xhtml">

	<head runat="server">
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="ie=edge" />
		<title>来料标签</title>
		<!-- 引入样式 -->
		<link rel="stylesheet" href="./css/element-ui-index.css" />
		<link rel="stylesheet" href="./css/theme-chalk-index.css" />
		<link href="./css/tabulator.min.css" rel="stylesheet" />
		<link href="./js/layui/css/layui.css" rel="stylesheet" />
		<link href="./css/index.css" rel="stylesheet" />
		<link href="./css/noborder.css" rel="stylesheet" />
		<link href="./css/tool.css" rel="stylesheet" />
	</head>

	<body>
		<asp:Label ID="lblUserName" runat="server" Visible="false"></asp:Label>
		<asp:Label ID="lbUserId" runat="server" Visible="false"></asp:Label>
		<asp:Label ID="lbAccount" runat="server" Visible="false"></asp:Label>
		<asp:Label ID="lbDataBase" runat="server" Visible="false"></asp:Label>
		<div id="app">
			<el-container class="contain">
				<el-header id="header" style="height: inherit !important;padding:0 !important">
					<div id="toolbarContainer" class="t-page-tb" style="position: relative; z-index: 999;">
						<div id="toolbarContainer-ct" class="tb-bg">
							<ul id="toolbarContainer-gp" class="tb-group tb-first-class">
								<li tabindex="0">
									<a href=" javascript:void(0)" @click='doQuery'>
										<span class="tb-item"><span class="tb-text" title="查询">查询</span></span>
									</a>
								</li>
								<li tabindex="1">
									<a href=" javascript:void(0)" @click='doRefresh'>
										<span class="tb-item"><span class="tb-text" title="刷新">刷新</span></span>
									</a>
								</li>
								<li tabindex="2">
									<a href=" javascript:void(0)" @click='doDesign'>
										<span class="tb-item"><span class="tb-text" title="标签设计">标签设计</span></span>
									</a>
								</li>
								<li tabindex="3">
									<a href=" javascript:void(0)" @click='doPreview'>
										<span class="tb-item"><span class="tb-text" title="标签预览">标签预览</span></span>
									</a>
								</li>
								<li tabindex="4">
									<a href=" javascript:void(0)" @click='doPrint'>
										<span class="tb-item"><span class="tb-text" title="标签打印">标签打印</span></span>
									</a>
								</li>
							</ul>
						</div>
					</div>
				</el-header>
				<el-row :gutter="1" style="padding: 0px 10px">
					<el-col :span="24">
						<el-tabs v-model="activeName" @tab-click="handleClick">
							<el-tab-pane label="按进货单打印" name="tab1">
								<div id='grid1'></div>
							</el-tab-pane>
							<el-tab-pane label="标签补打" name="tab2">
								<div id='grid2'></div>
							</el-tab-pane>
							<el-tab-pane label="库存补打" name="tab3">
								<div id='grid3'></div>
							</el-tab-pane>
						</el-tabs>
						<div style='border-bottom: 1px solid #F0F0F0;'>
							<p id='state' style="padding: 5px;">通讯连接中...</p>
						</div>
					</el-col>
				</el-row>
			</el-container>
		</div>

		<!-- import 工具类 -->
		<script src="./js/poly/js.polyfills.js"></script>
		<script src="./js/poly/es5.polyfills.js"></script>
		<script src="./js/poly/proxy.min.js"></script>
		<script src="./js/lang.js"></script>
		<!-- import Vue before Element -->
		<script src="./js/jquery.min.js"></script>
		<script src="./js/luxon.min.js"></script>
		<script src="./js/dayjs.min.js"></script>
		<script src="./js/tableconfig.js"></script>
		<script src="./js/vue.js"></script>
		<script src="./js/element-ui-index.js"></script>
		<script src="./js/tabulator.js"></script>
		<script src="./js/math/math.min.js"></script>
		<script>
			var loginName = "<%=lblUserName.Text%>";
			var loginUserId = "<%=lbUserId.Text%>";
			var accounId = '<%=lbAccount.Text%>'
            var database = '<%=lbDataBase.Text%>'
        </script>
		<script src="./js/layui/layui.js"></script>
		<script src="./js/dialog/dialog.js"></script>

		<script src="./js/rpt.js"></script>
	</body>

	</html>