From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 5/5] dax: handle media errors in dax_do_io
Date: Fri, 25 Mar 2016 22:36:17 +0000
Message-ID: <1458945374.5501.9.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	 <1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
	 <20160325104549.GB10525@infradead.org> <1458939566.5501.5.camel@intel.com>
	 <CAPcyv4jFPYYP=eL72V6MmW2fcXFP3PfQfcO+zYV4NN7rdu1ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9967 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbcCYWgu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Mar 2016 18:36:50 -0400
In-Reply-To: <CAPcyv4jFPYYP=eL72V6MmW2fcXFP3PfQfcO+zYV4NN7rdu1ksg@mail.gmail.com>
Content-Language: en-US
Content-ID: <D29E0545A3E9D4499429DC06CF52E08B@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T24gRnJpLCAyMDE2LTAzLTI1IGF0IDE0OjQyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgTWFyIDI1LCAyMDE2IGF0IDE6NTkgUE0sIFZlcm1hLCBWaXNoYWwgTA0KPiA8dmlz
aGFsLmwudmVybWFAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiBPbiBGcmksIDIwMTYtMDMt
MjUgYXQgMDM6NDUgLTA3MDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiA+ID4gDQo+ID4g
PiBPbiBUaHUsIE1hciAyNCwgMjAxNiBhdCAwNToxNzozMFBNIC0wNjAwLCBWaXNoYWwgVmVybWEg
d3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gZGF4X2RvX2lvIChjYWxsZWQgZm9y
IHJlYWQoKSBvciB3cml0ZSgpIGZvciBhIGRheCBmaWxlIHN5c3RlbSkNCj4gPiA+ID4gbWF5DQo+
ID4gPiA+IGZhaWwNCj4gPiA+ID4gaW4gdGhlIHByZXNlbmNlIG9mIGJhZCBibG9ja3Mgb3IgbWVk
aWEgZXJyb3JzLiBTaW5jZSB3ZSBleHBlY3QNCj4gPiA+ID4gdGhhdA0KPiA+ID4gPiBhDQo+ID4g
PiA+IHdyaXRlIHNob3VsZCBjbGVhciBtZWRpYSBlcnJvcnMgb24gbnZkaW1tcywgbWFrZSBkYXhf
ZG9faW8gZmFsbA0KPiA+ID4gPiBiYWNrIHRvDQo+ID4gPiA+IHRoZSBkaXJlY3RfSU8gcGF0aCwg
d2hpY2ggd2lsbCBzZW5kIGRvd24gYSBiaW8gdG8gdGhlIGRyaXZlciwNCj4gPiA+ID4gd2hpY2gN
Cj4gPiA+ID4gY2FuDQo+ID4gPiA+IHRoZW4gYXR0ZW1wdCB0byBjbGVhciB0aGUgZXJyb3IuDQo+
ID4gPiBMZWF2ZSB0aGUgZmFsbGJhY2sgb24gLUVJTyB0byB0aGUgY2FsbGVycyBwbGVhc2UuwqDC
oFRoZXkgZ2VuZXJhbGx5DQo+ID4gPiBjYWxsDQo+ID4gPiBfX2Jsb2NrZGV2X2RpcmVjdF9JTyBh
bnl3YXksIHNvIGl0IHNob3VsZCBhY3R1YWxseSBiZWNvbWUgc2ltcGxlcg0KPiA+ID4gdGhhdA0K
PiA+ID4gd2F5Lg0KPiA+IEkgdGhvdWdodCBvZiB0aGlzLCBidXQgbWFkZSB0aGUgcmV0cnlpbmcg
aGFwcGVuIGluIHRoZSB3cmFwcGVyIHNvDQo+ID4gdGhhdA0KPiA+IGl0IGNhbiBiZSBjZW50cmFs
aXplZC4gSWYgdGhlIGNhbGxlcnMgd2VyZSB0byBiZWNvbWUgcmVzcG9uc2libGUNCj4gPiBmb3IN
Cj4gPiB0aGUgcmV0cnksIHRoZW4gYW55IG5ldyBjYWxsZXJzIG9mIGRheF9kb19pbyBtaWdodCBu
b3QgcmVhbGl6ZSB0aGV5DQo+ID4gYXJlDQo+ID4gcmVzcG9uc2libGUgZm9yIHJldHJ5aW5nLCBh
bmQgaGl0IHByb2JsZW1zLg0KPiBUaGF0J3MgdGhlaXIgcHJlcm9nYXRpdmUgb3RoZXJ3aXNlIHlv
dSBhcmUgcHJlY2x1ZGluZyBhbiBhbHRlcm5hdGUNCj4gaGFuZGxpbmcgb2YgYSBkYXhfZG9faW8o
KSBmYWlsdXJlLsKgwqBNYXliZSBhIGZzIG9yIHVwcGVyIGxheWVyIGNhbg0KPiByZWNvdmVyIGlu
IGEgZGlmZmVyZW50IG1hbm5lciB0aGFuIHJlLXN1Ym1pdCB0aGUgSS9PIHRvIHRoZQ0KPiBfX2Js
b2NrZGV2X2RpcmVjdF9JTyBwYXRoLg0KDQpJJ20gaGFwcHkgdG8gbWFrZSB0aGUgY2hhbmdlLCBi
dXQgd2UgZG9uJ3QgcHJlY2x1ZGUgdGhhdCAtLSBfX2RheF9kb19pbw0KaXMgc3RpbGwgZXhwb3J0
ZWQgYW5kIGF2YWlsYWJsZS4u
