var dialog = {};
function init(opt) {
  const self = (dialog = new Vue({
    el: "#app",
    data() {
      return {
        form: {
          startDate: "",
          endDate: "",
          inv: "",
          orderNo: "",
          partner: "",
          batchNo: "",
          barcode: "",
          invStd: "",
          whName: "",
          posName: ""
        },
      };
    },
    methods: {
    },
    computed: {
      fromTab1() {
        return opt.fromTab == 'tab1' || opt.fromTab == 'tab4'
      },
      fromTab2() {
        return opt.fromTab == 'tab2'
      },
      fromTab3() {
        return opt.fromTab == 'tab3'
      }
    },
    watch: {},
    mounted() {
      this.form = opt.parent.queryForm;
    },
  }));
}

function getSelect() {
  if (dialog.fromTab1) {
    return [dialog.form].map(function (m) {
      var t = {};
      t.startDate = Date.parse(m.startDate)
        ? dayjs(m.startDate).format("YYYY-MM-DD")
        : "";
      t.endDate = Date.parse(m.endDate)
        ? dayjs(m.endDate).format("YYYY-MM-DD")
        : "";
      t.inv = m.inv;
      t.orderNo = m.orderNo;
      t.partner = m.partner;
      t.invStd = m.invStd;
      return t;
    });
  } else if (dialog.fromTab2) {
    return [dialog.form].map(function (m) {
      var t = {};
      t.startDate = Date.parse(m.startDate)
        ? dayjs(m.startDate).format("YYYY-MM-DD")
        : "";
      t.endDate = Date.parse(m.endDate)
        ? dayjs(m.endDate).format("YYYY-MM-DD")
        : "";
      t.inv = m.inv;
      t.partner = m.partner;
      t.batchNo = m.batchNo;
      t.barcode = m.barcode;
      t.invStd = m.invStd;
      return t;
    });
  } else if (dialog.fromTab3) {
    return [dialog.form].map(function (m) {
      var t = {};
      t.inv = m.inv;
      t.batchNo = m.batchNo;
      t.whName = m.whName;
      t.posName = m.posName;
      return t;
    });
  }
}
