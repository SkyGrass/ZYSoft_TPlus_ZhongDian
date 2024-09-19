var dialog = {};
function init(opt) {
    const self = (dialog = new Vue({
        el: "#app",
        data() {
            return {
                form: {},
                packQtyList: []
            };
        },
        methods: {
            changeNum(item, index) {
                item.copy = item.qty > 0 ? 1 : 0;
                this.$set(this.packQtyList, index, item)
            },
        },
        computed: {
            curSum() {
                return this.packQtyList.map(function (f) { return f.qty })
                    .reduce(function (accumulator, currentValue) {
                        return accumulator + currentValue
                    }, 0)
            }
        },
        watch: {},
        mounted() {
            this.packQtyList = new Array(20).fill(0).map(function () {
                return { qty: 0, copy: 0 }
            })
            this.form = opt.sourceRow;
        },
    }));
}

function getSelect() {
    var packQtyList = dialog.packQtyList;
    var sourceRow = dialog.form;
    var tar = packQtyList.filter(function (f) { return f.qty <= 0 });
    if (tar.length == packQtyList.length) {
        return layer.msg("请先填写包装数量!", { zIndex: new Date() * 1, icon: 5, });
    }
    var sum = packQtyList.map(function (f) { return f.qty })
        .reduce(function (accumulator, currentValue) {
            return accumulator + currentValue
        }, 0);
    if (sourceRow.iQuantity - sum < 0) {
        return layer.msg("包装数量超过限制!", { zIndex: new Date() * 1, icon: 5, });
    }
    return packQtyList.filter(function (f) { return f.qty > 0 && f.copy > 0 }).map(function (f) {
        return Object.assign({}, f, sourceRow);
    });
}
