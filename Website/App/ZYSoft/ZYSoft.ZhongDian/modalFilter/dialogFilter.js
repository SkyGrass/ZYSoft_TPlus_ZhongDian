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
          invStd: ""
        },
      };
    },
    methods: {
    },
    computed: {
      fromTab1() {
        return opt.fromTab == 'tab1'
      },
      fromTab2() {
        return opt.fromTab == 'tab2'
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
  }
}
