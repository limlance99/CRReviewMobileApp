(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-2d0a43c2"],{"0628":function(t,e,r){"use strict";r.r(e);var a=function(){var t=this,e=t.$createElement,r=t._self._c||e;return r("div",[r("section",{staticClass:"section"},[r("div",{staticClass:"container"},[r("h1",{staticClass:"title"},[t._v("CRs")]),r("h2",{staticClass:"subtitle"},[t._v(" This section shows a table containing all CRs in the database with their respective IDs, Locations, Floor, and Gender. ")]),r("CRList")],1)])])},n=[],s=function(){var t=this,e=t.$createElement,r=t._self._c||e;return r("section",[r("b-table",{ref:"table",attrs:{data:t.data,loading:t.tableLoading,"backend-sorting":"","default-sort-direction":t.defaultSortOrder,"default-sort":[t.sortField,t.sortOrder]},on:{sort:t.onSort},scopedSlots:t._u([{key:"default",fn:function(e){return[r("b-table-column",{attrs:{field:"id",label:"ID"}},[t._v(t._s(e.row.id))]),r("b-table-column",{attrs:{field:"createdat",label:"Created At"}},[t._v(t._s(t.parseDate(e.row.createdat)))]),r("b-table-column",{attrs:{field:"location.address",label:"Location"}},[t._v(t._s(e.row.location.address))]),r("b-table-column",{attrs:{field:"floor",label:"Floor"}},[t._v(t._s(e.row.floor))]),r("b-table-column",{attrs:{field:"gender",label:"Gender"}},[t._v(t._s(e.row.gender))]),r("b-table-column",{attrs:{label:"Edit"}},[r("b-button",{attrs:{type:"is-success"},on:{click:function(r){return t.goToReviews(e.row.id)}}},[t._v("Edit Reviews")])],1),r("b-table-column",{attrs:{label:"Delete"}},[r("b-button",{attrs:{type:"is-warning"},on:{click:function(r){return t.removeCR(e.row.id)}}},[t._v("Delete")])],1)]}}])},[r("template",{slot:"empty"},[t.tableLoading?r("p",[t._v("Loading...")]):r("p",[t._v(t._s(t.DetailMessage))])])],2)],1)},o=[],i=(r("a4d3"),r("4de4"),r("4160"),r("0d03"),r("e439"),r("dbb4"),r("b64b"),r("ac1f"),r("5319"),r("159b"),r("96cf"),r("89ba")),c=r("2fa7"),l=r("2f62");function u(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(t);e&&(a=a.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,a)}return r}function d(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?u(r,!0).forEach((function(e){Object(c["a"])(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):u(r).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}var b={data:function(){return{data:[],tableLoading:!1,defaultSortOrder:"desc",sortField:"fullname",sortOrder:"desc",DetailMessage:"Nothing Here"}},computed:d({},Object(l["c"])(["ListofCRs"])),methods:d({},Object(l["b"])(["fetchTable","deleteCR"]),{onSort:function(){var t=Object(i["a"])(regeneratorRuntime.mark((function t(e,r){var a;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.sortField=e,this.sortOrder=r,this.tableLoading=!0,a={table:"crs",field:e,order:r},t.next=6,this.fetchTable(a);case 6:this.data=this.ListofCRs,this.tableLoading=!1;case 8:case"end":return t.stop()}}),t,this)})));function e(e,r){return t.apply(this,arguments)}return e}(),parseDate:function(t){var e=new Date(t.replace(" ","T"));return e},goToReviews:function(t){this.$router.push({path:"/reviews/".concat(t)})},removeCR:function(){var t=Object(i["a"])(regeneratorRuntime.mark((function t(e){var r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.tableLoading=!0,t.next=3,this.deleteCR(e);case 3:r=t.sent,r?(this.data=this.ListofCRs,this.$buefy.toast.open("CR deleted successfully!")):this.$buefy.toast.open("An error occured :("),this.tableLoading=!1;case 6:case"end":return t.stop()}}),t,this)})));function e(e){return t.apply(this,arguments)}return e}()}),mounted:function(){var t=Object(i["a"])(regeneratorRuntime.mark((function t(){var e,r;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return this.tableLoading=!0,e={table:"crs",field:this.sortField,order:this.sortOrder},t.next=4,this.fetchTable(e);case 4:r=t.sent,t.t0=r,t.next=200===t.t0?8:409===t.t0?10:13;break;case 8:return this.data=this.ListofCRs,t.abrupt("break",15);case 10:return this.data=[],this.DetailMessage="Nothing Here",t.abrupt("break",15);case 13:this.data=[],this.DetailMessage="Could not connect to the database.";case 15:this.tableLoading=!1;case 16:case"end":return t.stop()}}),t,this)})));function e(){return t.apply(this,arguments)}return e}()},f=b,h=r("2877"),p=Object(h["a"])(f,s,o,!1,null,null,null),v=p.exports,g={name:"CRs",components:{CRList:v}},w=g,m=Object(h["a"])(w,a,n,!1,null,null,null);e["default"]=m.exports}}]);
//# sourceMappingURL=chunk-2d0a43c2.d4f83264.js.map