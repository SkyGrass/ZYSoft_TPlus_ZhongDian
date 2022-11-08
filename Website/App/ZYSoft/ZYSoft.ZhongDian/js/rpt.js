var socket = undefined;
var timer = undefined;
var DESIGN = 1, PREVIEW = 2, PRINT = 3;
var BILL = 1, REPRINT = 2, STOCK = 3;
var RPTID = 1
var self = (vm = new Vue({
  el: "#app",
  data: function () {
    return {
      queryForm: {
        startDate: new Date(),
        endDate: new Date(),
        inv: "",
        orderNo: "",
        partner: "",

        whName: "",
        posName: "",

        batchNo: "",
        barcode: "",
        invStd: "",
        db: database,
        accId: accounId || 1,
      },

      activeName: "tab1",
      grid1: {},
      grid2: {},
      grid3: {},
    };
  },
  computed: {},
  methods: {
    doQuery() {
      openDialog({
        title: "查询",
        url: "./modalFilter/ModalFilter.aspx",
        area: ["800px", "500px"],
        onSuccess: function (layero, index, layer) {
          layer.setTop(layero);
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          iframeWin.init({ parent: self, fromTab: self.activeName });
        },
        onBtnYesClick: function (index, layero, layer) {
          var iframeWin = window[layero.find("iframe")[0]["name"]];
          var row = iframeWin.getSelect();
          if (row != void 0 && row.length > 0) {
            row = row[0];
            if (row != void 0) {
              if (self.activeName == 'tab1') {
                self.queryGrid1(row);
              } else if (self.activeName == 'tab2') {
                self.queryGrid2(row);
              } else if (self.activeName == 'tab3') {
                self.queryGrid3(row);
              }
            }

            layer.close(index);
          }
        },
      });
    },
    doDesign() {
      layer.confirm(
        "确定要设计模板吗?",
        { icon: 3, title: "提示" },
        function (index) {
          self.doSend(DESIGN, [])
          setTimeout(function () {
            layer.close(index);
          }, 1000);
        });
    },
    doRefresh() {
      if (this.activeName == 'tab1') {
        this.queryGrid1()
      } else if (this.activeName == 'tab2') {
        this.queryGrid2()
      } else if (this.activeName == 'tab3') {
        this.queryGrid3()
      }
    },
    doPreview() {
      var data = [];
      if (this.activeName == 'tab1') {
        data = this.grid1.getSelectedData()
      } else if (this.activeName == 'tab2') {
        data = this.grid2.getSelectedData()
      } else if (this.activeName == 'tab3') {
        data = this.grid3.getSelectedData()
      }
      var vaild = data.some(function (f) { return f['iPackQuantity' || 'FQty'] <= 0 });
      if (self.activeName == 'tab3' && !vaild) {
        vaild = data.some(function (f) {
          return f['iPrintQty'] <= 0
        });
      }
      if (vaild > 0) {
        return layer.msg("发现数量为0的记录被选中!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
      if (data.length > 0) {
        layer.confirm(
          "确定要预览标签吗?",
          { icon: 3, title: "提示" },
          function (index) {
            self.doSend(PREVIEW, data.map(function (f) {
              return {
                FEntryID: self.activeName == 'tab1' ? f.EnryID : (f.ID || f.id),
                FPackQty: f.iPackQuantity || f.FQty,
                FBatch: f.cBatch || f.FBatch,
                FPrintQty: f.iPrintQty
              }
            }))
            setTimeout(function () {
              layer.close(index);
            }, 1000);
          });

      } else {
        return layer.msg("请先选择要预览的数据!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
    },
    doPrint() {
      var data = [];
      if (this.activeName == 'tab1') {
        data = this.grid1.getSelectedData()
      } else if (this.activeName == 'tab2') {
        data = this.grid2.getSelectedData()
      } else if (this.activeName == 'tab3') {
        data = this.grid3.getSelectedData()
      }
      var vaild = data.some(function (f) {
        return f['iPackQuantity' || 'FQty'] <= 0
      });
      if (self.activeName == 'tab3' && !vaild) {
        vaild = data.some(function (f) {
          return f['iPrintQty'] <= 0
        });
      }
      if (vaild > 0) {
        return layer.msg("发现数量为0的记录被选中!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
      if (data.length > 0) {
        layer.confirm(
          "确定要打印标签吗?",
          { icon: 3, title: "提示" },
          function (index) {
            var _index = layer.load(2);
            self.doSend(PRINT, data.map(function (f) {
              return {
                FEntryID: self.activeName == 'tab1' ? f.EnryID : (f.ID || f.id),
                FPackQty: f.iPackQuantity || f.FQty,
                FBatch: f.cBatch || f.FBatch,
                FPrintQty: f.iPrintQty
              }
            }));
            setTimeout(function () {
              layer.close(index);
              layer.close(_index);
            }, 1000);
          });
      } else {
        return layer.msg("请先选择要打印的数据!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
    },
    doSend(flag, data) {
      if (socket && socket.readyState == "1") {
        socket.send(JSON.stringify(
          $.extend({},
            {
              FType: flag,
              FBillType: self.activeName == 'tab1' ? BILL : (self.activeName == 'tab2' ? REPRINT : STOCK),
              FAccountID: accounId
            },
            { Entry: data }
          )))
      } else {
        return layer.msg("通讯服务未链接,请刷新!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
    },
    initGrid(opt) {
      var gridId = opt.gridId,
        columns = opt.columns,
        callback = opt.callback,
        key = opt.key || "";
      var maxHeight =
        $(window).height() -
        $("#toolbarContainer").height() -
        85;
      this[gridId] = new Tabulator("#" + gridId, {
        layout: "fitColumns",
        locale: true,
        langs: langs,
        height: maxHeight,
        columnHeaderVertAlign: "bottom",
        columns: columns,
        index: 'rid',
        data: [],
        selectable: true,
        ajaxResponse: function (url, params, response) {
          if (response.state == "success") {
            var t = response.data.map(function (m, i) {
              if (self.activeName == 'tab1') {
                m.voucherDate = dayjs(m.voucherdate).format("YYYY-MM-DD");
              }
              m.rid = i + 1;
              return m;
            });
            return t;
          } else {
            layer.msg("没有查询到数据", { icon: 5 });
            return [];
          }
        }
      });

      this[gridId].on("renderComplete", function () {
        console.log(gridId)
        self.setRowSelect(gridId)
      });

      this[gridId].on("scrollVertical", function () {
        console.log(gridId)
        self.setRowSelect(gridId)
      });
    },
    setRowSelect(gridId) {
      $('.tabulator-cell input[type="checkbox"]').off('click').on('click', function (e, a) {
        var id = $(this).parent().next().next().html();
        if (id != void 0) {
          var keyField = self.activeName == 'tab1' ? 'EnryID' : 'ID'
          if (self.activeName == 'tab1') {
            gridId = 'grid1'
          } else if (self.activeName == 'tab2') {
            gridId = 'grid2'
          }
          var rows = self[gridId].getData();
          var selRows = self[gridId].getSelectedData();
          if (rows.length > 0) {
            var ps = rows.filter(function (row) {
              return row[keyField] == id
            })
            if (ps.length > 0) {
              ps.forEach(function (p) {
                var cs = selRows.filter(function (ff) { return ff[keyField] == p[keyField] })
                if (cs.length > 0) {
                  var _p = rows.findIndex(function (ff) { return ff[keyField] == cs[0][keyField] })
                  self[gridId].deselectRow(_p + 1)
                } else {
                  var _p = rows.findIndex(function (ff) { return ff[keyField] == p[keyField] })
                  self[gridId].selectRow(_p + 1)
                }
              });
            }
          }
        }
      });
    },
    handleClick(tab, event) {
      if (self.activeName == 'tab1') return;
      if (self.activeName == 'tab2') {
        var ps = Object.keys(self.grid2);
        if (ps.length <= 0) {
          this.initGrid({
            gridId: "grid2",
            key: "ID",
            columns: [
              {
                width: 80,
                title: "操作",
                formatter: "rowSelection",
                titleFormatter: "rowSelection",
                headerHozAlign: "center",
                hozAlign: "center",
                headerSort: false,
              },
            ].concat(grid2TableConf),
          });
        }
      }
      if (self.activeName == 'tab3') {
        var ps = Object.keys(self.grid3);
        if (ps.length <= 0) {
          this.initGrid({
            gridId: "grid3",
            key: "id",
            columns: [
              {
                width: 80,
                title: "操作",
                formatter: "rowSelection",
                titleFormatter: "rowSelection",
                headerHozAlign: "center",
                hozAlign: "center",
                headerSort: false,
              },
            ].concat(grid3TableConf),
          });
        }
      }
    },
    queryGrid1(row) {
      var index = layer.load(2);
      setTimeout(function () {
        self.grid1.clearData();
        self.grid1.setData(
          "./ZhongDianHandler.ashx",
          Object.assign(
            {
              SelectApi: "getList1",
            },
            self.queryForm, row
          ),
          "POST"
        );
        layer.close(index);
      }, 500);
    },
    queryGrid2(row) {
      var index = layer.load(2);
      setTimeout(function () {
        self.grid2.clearData();
        self.grid2.setData(
          "./ZhongDianHandler.ashx",
          Object.assign(
            {
              SelectApi: "getList2",
            },
            self.queryForm, row
          ),
          "POST"
        );
        layer.close(index);
      }, 500);
    },
    queryGrid3(row) {
      var index = layer.load(2);
      setTimeout(function () {
        self.grid3.clearData();
        self.grid3.setData(
          "./ZhongDianHandler.ashx",
          Object.assign(
            {
              SelectApi: "getList3",
            },
            self.queryForm, row
          ),
          "POST"
        );
        layer.close(index);
      }, 500);
    },
    initSocket() {
      try {
        if (WebSocket) {
          socket = new WebSocket('ws://127.0.0.1:8181/');
          socket.addEventListener('open', function () {
            console.log('server is open');
            $('#state').css('color', 'green')
            $('#state').html("通讯服务已连接")
            timer = setInterval(function () { socket.send(JSON.stringify($.extend({}, { FType: 0, FTime: new Date() * 1 }))) }, 3000)
          });
          socket.addEventListener('message', function (e) {
            var data = e.data;
            if (data) {
              console.log(data)
            }
          });
          socket.addEventListener('close', function (e) {
            $('#state').css('color', 'red')
            $('#state').html("通讯服务已关闭")
            console.log('close' + e);
            if (timer) { clearInterval(timer); }
          });
          socket.addEventListener('error', function (e) {
            $('#state').css('color', 'red')
            $('#state').html("连接通讯服务发生错误")
            console.log('error' + e);
            if (timer) { clearInterval(timer); }
          });
        }
      } catch (e) {
        return layer.msg("通讯服务发生异常!", {
          zIndex: new Date() * 1,
          icon: 5,
        });
      }
    }
  },
  mounted() {
    this.initGrid({
      gridId: "grid1",
      key: "EnryID",
      columns: [
        {
          width: 80,
          title: "操作",
          formatter: "rowSelection",
          titleFormatter: "rowSelection",
          headerHozAlign: "center",
          hozAlign: "center",
          headerSort: false,
        },
      ].concat(grid1TableConf),
    });

    window.onresize = function () {
      self.grid1.setHeight(
        $(window).height() -
        $("#toolbarContainer").height() -
        85
      );

      var ps = Object.keys(self.grid2);
      if (ps.length > 0) {
        self.grid2.setHeight(
          $(window).height() -
          $("#toolbarContainer").height() -
          85
        );
      }

      var ps3 = Object.keys(self.grid3);
      if (ps3.length > 0) {
        self.grid3.setHeight(
          $(window).height() -
          $("#toolbarContainer").height() -
          85
        );
      }
    };

    this.initSocket();
  },
}));
