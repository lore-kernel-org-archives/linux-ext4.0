From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Date: Fri, 25 Mar 2016 21:01:15 +0000
Message-ID: <1458939672.5501.6.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	 <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
	 <20160325104418.GA10525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: "hch@infradead.org" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64169 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855AbcCYVBR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Mar 2016 17:01:17 -0400
In-Reply-To: <20160325104418.GA10525@infradead.org>
Content-Language: en-US
Content-ID: <C1CC86445350EC46A0E9EAEF3480691D@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T24gRnJpLCAyMDE2LTAzLTI1IGF0IDAzOjQ0IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gT24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgMDU6MTc6MjlQTSAtMDYwMCwgVmlzaGFsIFZl
cm1hIHdyb3RlOg0KPiA+IA0KPiA+IEBAIC03MiwxNiArNzIsNyBAQCB4ZnNfemVyb19leHRlbnQo
DQo+ID4gwqAJc3RydWN0IHhmc19tb3VudCAqbXAgPSBpcC0+aV9tb3VudDsNCj4gPiDCoAl4ZnNf
ZGFkZHJfdAlzZWN0b3IgPSB4ZnNfZnNiX3RvX2RiKGlwLCBzdGFydF9mc2IpOw0KPiA+IMKgCXNl
Y3Rvcl90CWJsb2NrID0gWEZTX0JCX1RPX0ZTQlQobXAsIHNlY3Rvcik7DQo+ID4gLQlzc2l6ZV90
CQlzaXplID0gWEZTX0ZTQl9UT19CKG1wLCBjb3VudF9mc2IpOw0KPiA+IMKgDQo+ID4gLQlpZiAo
SVNfREFYKFZGU19JKGlwKSkpDQo+ID4gLQkJcmV0dXJuDQo+ID4gZGF4X2NsZWFyX3NlY3RvcnMo
eGZzX2ZpbmRfYmRldl9mb3JfaW5vZGUoVkZTX0koaXApKSwNCj4gPiAtCQkJCXNlY3Rvciwgc2l6
ZSk7DQo+ID4gLQ0KPiA+IC0JLyoNCj4gPiAtCcKgKiBsZXQgdGhlIGJsb2NrIGxheWVyIGRlY2lk
ZSBvbiB0aGUgZmFzdGVzdCBtZXRob2Qgb2YNCj4gPiAtCcKgKiBpbXBsZW1lbnRpbmcgdGhlIHpl
cm9pbmcuDQo+ID4gLQnCoCovDQo+ID4gwqAJcmV0dXJuIHNiX2lzc3VlX3plcm9vdXQobXAtPm1f
c3VwZXIsIGJsb2NrLCBjb3VudF9mc2IsDQo+ID4gR0ZQX05PRlMpOw0KPiBXaGlsZSBub3QgbmV3
OiB1c2luZyBzYl9pc3N1ZV96ZXJvb3V0IGluIFhGUyBpcyB3cm9uZyBhcyBpdCBkb2Vzbid0DQo+
IGFjY291bnQgZm9yIHRoZSBSVCBkZXZpY2UuwqDCoFdlIG5lZWQgdGhlIHhmc19maW5kX2JkZXZf
Zm9yX2lub2RlIGFuZA0KPiBjYWxsIGJsa2Rldl9pc3N1ZV96ZXJvb3V0IGRpcmVjdGx5IHdpdGgg
dGhlIGJkZXYgaXQgcmV0dXJuZWQuDQoNCk9rLCBJJ2xsIGZpeCBhbmQgc2VuZCBhIHYyLiBUaGFu
a3MhDQo+IA==
