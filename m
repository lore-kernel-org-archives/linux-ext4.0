From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Sat, 23 Apr 2016 18:08:37 +0000
Message-ID: <1461434916.3695.7.camel@intel.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	 <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	 <x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	 <20160420205923.GA24797@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-nvdimm@ml01.01.org"
	<linux-nvdimm@ml01.01.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "axboe@fb.com"
	<axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
To: "hch@infradead.org" <hch@infradead.org>, "jmoyer@redhat.com"
	<jmoyer@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160420205923.GA24797@infradead.org>
Content-Language: en-US
Content-ID: <627BD94691203943AE9F3F8DCFC1876B@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCAyMDE2LTA0LTIwIGF0IDEzOjU5IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gRnJpLCBBcHIgMTUsIDIwMTYgYXQgMTI6MTE6MzZQTSAtMDQwMCwgSmVmZiBNb3ll
ciB3cm90ZToNCj4gPiANCj4gPiA+IA0KPiA+ID4gKwlpZiAoSVNfREFYKGlub2RlKSkgew0KPiA+
ID4gKwkJcmV0ID0gZGF4X2RvX2lvKGlvY2IsIGlub2RlLCBpdGVyLCBvZmZzZXQsDQo+ID4gPiBi
bGtkZXZfZ2V0X2Jsb2NrLA0KPiA+ID4gwqAJCQkJTlVMTCwgRElPX1NLSVBfRElPX0NPVU5UKTsN
Cj4gPiA+ICsJCWlmIChyZXQgPT0gLUVJTyAmJiAoaW92X2l0ZXJfcncoaXRlcikgPT0gV1JJVEUp
KQ0KPiA+ID4gKwkJCXJldF9zYXZlZCA9IHJldDsNCj4gPiA+ICsJCWVsc2UNCj4gPiA+ICsJCQly
ZXR1cm4gcmV0Ow0KPiA+ID4gKwl9DQo+ID4gPiArDQo+ID4gPiArCXJldCA9IF9fYmxvY2tkZXZf
ZGlyZWN0X0lPKGlvY2IsIGlub2RlLCBJX0JERVYoaW5vZGUpLA0KPiA+ID4gaXRlciwgb2Zmc2V0
LA0KPiA+ID4gwqAJCQkJwqDCoMKgwqBibGtkZXZfZ2V0X2Jsb2NrLCBOVUxMLA0KPiA+ID4gTlVM
TCwNCj4gPiA+IMKgCQkJCcKgwqDCoMKgRElPX1NLSVBfRElPX0NPVU5UKTsNCj4gPiA+ICsJaWYg
KHJldCA8IDAgJiYgcmV0X3NhdmVkKQ0KPiA+ID4gKwkJcmV0dXJuIHJldF9zYXZlZDsNCj4gPiA+
ICsNCj4gPiBIbW0sIGRpZCB5b3UganVzdCBicmVhayBhc3luYyBESU8/wqDCoEkgdGhpbmsgeW91
IGRpZCHCoMKgOikNCj4gPiBfX2Jsb2NrZGV2X2RpcmVjdF9JTyBjYW4gcmV0dXJuIC1FSU9DQlFV
RVVFRCwgYW5kIHlvdSd2ZSBub3cgdHVybmVkDQo+ID4gdGhhdA0KPiA+IGludG8gLUVJTy7CoMKg
UmVhbGx5LCBJIGRvbid0IHNlZSBhIHJlYXNvbiB0byBzYXZlIHRoYXQgZmlyc3QNCj4gPiAtRUlP
LsKgwqBUaGUNCj4gPiBzYW1lIGFwcGxpZXMgdG8gYWxsIGluc3RhbmNlcyBpbiB0aGlzIHBhdGNo
Lg0KPiBZZXMsIHRoZXJlIGlzIG5vIHBvaW50IGluIHNhdmluZyB0aGUgZWFybGllciBlcnJvciAt
IGp1c3QgcmV0dXJuIHRoZQ0KPiBzZWNvbmQgZXJyb3IgYWxsIHRoZSB0aW1lLg0KDQpJcyBpdCBv
ayB0byBkbyB0aGF0Pw0KDQpkaXJlY3RfSU8gbWlnaHQgZmFpbCB3aXRoIC1FSU5WQUwgZHVlIHRv
IG1pc2FsaWdubWVudCwgb3IgLUVOT01FTSBkdWUNCnRvIHNvbWUgYWxsb2NhdGlvbiBmYWlsaW5n
LCBhbmQgSSB0aG91Z2h0IHdlIHNob3VsZCByZXR1cm4gdGhlIG9yaWdpbmFsDQotRUlPIGluIHN1
Y2ggY2FzZXMgc28gdGhhdCB0aGUgYXBwbGljYXRpb24gZG9lc24ndCBsb3NlIHRoZSBpbmZvcm1h
dGlvbg0KdGhhdCB0aGUgYmFkIGJsb2NrIGlzIGFjdHVhbGx5IGNhdXNpbmcgdGhlIGVycm9yLg0K
DQo+IA0KPiBFLmcuDQo+IA0KPiAJcmV0ID0gZGF4X2lvKCk7DQo+IAlpZiAoZGF4X25lZWRfZGlv
X3JldHJ5KHJldCkpDQo+IAkJcmV0ID0gZGlyZWN0X0lPKCk7DQo+IA==

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
