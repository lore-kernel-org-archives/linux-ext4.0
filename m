From: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH v2 0/9] re-enable DAX PMD support
Date: Wed, 31 Aug 2016 22:08:59 +0000
Message-ID: <1472681284.2092.30.camel@hpe.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160830230150.GA12173@linux.intel.com> <1472674799.2092.19.camel@hpe.com>
 <20160831213607.GA6921@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "tytso-3s7WtUTddSA@public.gmane.org" <tytso-3s7WtUTddSA@public.gmane.org>,
 "mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 "david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>,
 "adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org" <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
 "jack-IBi9RG/b67k@public.gmane.org" <jack-IBi9RG/b67k@public.gmane.org>,
 "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: "ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160831213607.GA6921-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Content-Language: en-US
Content-ID: <9CF8BC9D254DF144AF101EE6F7D0B3D0-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCAyMDE2LTA4LTMxIGF0IDE1OjM2IC0wNjAwLCBSb3NzIFp3aXNsZXIgd3JvdGU6DQo+
IE9uIFdlZCwgQXVnIDMxLCAyMDE2IGF0IDA4OjIwOjQ4UE0gKzAwMDAsIEthbmksIFRvc2hpbWl0
c3Ugd3JvdGU6DQo+ID4gDQo+ID4gT24gVHVlLCAyMDE2LTA4LTMwIGF0IDE3OjAxIC0wNjAwLCBS
b3NzIFp3aXNsZXIgd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9uIFR1ZSwgQXVnIDIzLCAyMDE2IGF0
IDA0OjA0OjEwUE0gLTA2MDAsIFJvc3MgWndpc2xlciB3cm90ZToNCsKgOg0KPiA+ID4gDQo+ID4g
PiBQaW5nIG9uIHRoaXMgc2VyaWVzP8KgwqBBbnkgb2JqZWN0aW9ucyBvciBjb21tZW50cz8NCj4g
PiANCj4gPiBIaSBSb3NzLA0KPiA+IA0KPiA+IEkgYW0gc2VlaW5nIGEgbWFqb3IgcGVyZm9ybWFu
Y2UgbG9zcyBpbiBmaW8gbW1hcCB0ZXN0IHdpdGggdGhpcw0KPiA+IHBhdGNoLXNldCBhcHBsaWVk
LiDCoFRoaXMgaGFwcGVucyB3aXRoIG9yIHdpdGhvdXQgbXkgcGF0Y2hlcyBbMV0NCj4gPiBhcHBs
aWVkIG9uIHRvcCBvZiB5b3Vycy4gwqBXaXRob3V0IG15IHBhdGNoZXMswqBkYXhfcG1kX2ZhdWx0
KCkgZmFsbHMNCj4gPiBiYWNrIHRvIHRoZSBwdGUgaGFuZGxlciBzaW5jZSBhbiBtbWFwJ2VkIGFk
ZHJlc3MgaXMgbm90IDJNQi0NCj4gPiBhbGlnbmVkLg0KPiA+IA0KPiA+IEkgaGF2ZSBhdHRhY2hl
ZCB0aHJlZSB0ZXN0IHJlc3VsdHMuDQo+ID4gwqBvIHJjNC5sb2cgLSA0LjguMC1yYzQgKGJhc2Up
DQo+ID4gwqBvIG5vbi1wbWQubG9nIC0gNC44LjAtcmM0ICsgeW91ciBwYXRjaHNldCAoZmFsbCBi
YWNrIHRvIHB0ZSkNCj4gPiDCoG8gcG1kLmxvZyAtIDQuOC4wLXJjNCArIHlvdXIgcGF0Y2hzZXQg
KyBteSBwYXRjaHNldCAodXNlIHBtZCBtYXBzKQ0KPiA+IA0KPiA+IE15IHRlc3Qgc3RlcHMgYXJl
IGFzIGZvbGxvd3MuDQo+ID4gDQo+ID4gbWtmcy5leHQ0IC1PIGJpZ2FsbG9jIC1DIDJNIC9kZXYv
cG1lbTANCj4gPiBtb3VudCAtbyBkYXggL2Rldi9wbWVtMCAvbW50L3BtZW0wDQo+ID4gbnVtYWN0
bCAtLXByZWZlcnJlZCBibG9jazpwbWVtMCAtLWNwdW5vZGViaW5kIGJsb2NrOnBtZW0wIGZpbw0K
PiA+IHRlc3QuZmlvDQo+ID4gDQo+ID4gInRlc3QuZmlvIg0KPiA+IC0tLQ0KPiA+IFtnbG9iYWxd
DQo+ID4gYnM9NGsNCj4gPiBzaXplPTJHDQo+ID4gZGlyZWN0b3J5PS9tbnQvcG1lbTANCj4gPiBp
b2VuZ2luZT1tbWFwDQo+ID4gW3JhbmRyd10NCj4gPiBydz1yYW5kcncNCj4gPiAtLS0NCj4gPiAN
Cj4gPiBDYW4geW91IHBsZWFzZSB0YWtlIGEgbG9vaz8NCj4gDQo+IFllcCwgdGhhbmtzIGZvciB0
aGUgcmVwb3J0Lg0KDQpJIGhhdmUgc29tZSBtb3JlIG9ic2VydmF0aW9ucy4gwqBJdCBzZWVtcyB0
aGlzIGlzc3VlIGlzIHJlbGF0ZWQgd2l0aCBwbWQNCm1hcHBpbmdzIGFmdGVyIGFsbC4gwqBmaW8g
Y3JlYXRlcyAicmFuZHJ3LjAuMCIgZmlsZS4gwqBJbiBteSBzZXR1cCwgYW4NCmluaXRpYWwgdGVz
dCBydW4gY3JlYXRlcyBwbWQgbWFwcGluZ3MgYW5kIGhpdHMgdGhpcyBpc3N1ZS4gwqBTdWJzZXF1
ZW50DQp0ZXN0IHJ1bnMgKGkuZS4gcmFuZHJ3LjAuMCBleGlzdHMpLCB3aXRob3V0IG15IHBhdGNo
ZXMsIGZhbGwgYmFjayB0bw0KcHRlIG1hcHBpbmdzIGFuZCBkbyBub3QgaGl0IHRoaXMgaXNzdWUu
IMKgV2l0aCBteSBwYXRjaGVzIGFwcGxpZWQsDQpzdWJzZXF1ZW50IHJ1bnMgc3RpbGwgY3JlYXRl
IHBtZCBtYXBwaW5ncyBhbmQgaGl0IHRoaXMgaXNzdWUuDQoNClRoYW5rcywNCi1Ub3NoaSDCoA0K
DQoNCg0KDQoNCg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
