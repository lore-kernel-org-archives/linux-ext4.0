From: Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Thu, 24 Sep 2015 08:40:18 +0000
Message-ID: <d6cf09f352a84b8d811da55fbc64a869@SIXPR30MB031.064d.mgd.msft.net>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
	 <1434495193-31182-3-git-send-email-tj@kernel.org>
	 <20150722035620.GD2944@thunk.org> <1443012552.19983.209.camel@gmail.com>
	 <20150923180934.GE26647@mtj.duckdns.org>
	 <20150923185137.GJ26647@mtj.duckdns.org>
	 <20150923210729.GA23180@mtj.duckdns.org>
 <1443082186.19983.234.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
	"cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>,
	"kernel-team-b10kYP2dOMg@public.gmane.org" <kernel-team-b10kYP2dOMg@public.gmane.org>,
	"adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org" <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443082186.19983.234.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

PiBPbiBXZWQsIDIwMTUtMDktMjMgYXQgMTc6MDcgLTA0MDAsIFRlanVuIEhlbyB3cm90ZToNCj4g
PiBIZWxsbywNCj4gPg0KPiA+IFNvLCB0aGlzIHNob3VsZCBtYWtlIHRoZSByZWdyZXNzaW9uIGdv
IGF3YXkuICBJdCBkb2Vzbid0IGZpeCB0aGUNCj4gPiB1bmRlcmx5aW5nIGJ1Z3MgYnV0IHRoZXkg
c2hvdWxkbid0IGdldCB0cmlnZ2VyZWQgYnkgcGVvcGxlIG5vdA0KPiA+IGV4cGVyaW1lbnRpbmcg
d2l0aCBjZ3JvdXAuDQo+IA0KPiBUZWp1biwNCj4gDQo+IHRoaXMgaGl0cyB0aGUgbmFpbCBvbiB0
aGUgaGVhZCBhbmQgbWFrZXMgdGhlIHByb2JsZW0gZ28gYXdheS4NCj4gDQo+IEkndmUgdGVzdGVk
IHRoZSB0aXAgb2YgTGludXNlcyB0cmVlICh2NC4zLXJjMispIHBsdXMgdGhpcyBwYXRjaCAtIG5v
DQo+IGRhdGEgY29ycnVwdGlvbiBhZnRlciByZWJvb3RzLg0KPiANCj4gSSd2ZSB0ZXN0ZWQganVz
dCB0aGUgdGlwIG9mIExpbnVzZXMgdHJlZSAodjQuMy1yYzIrKSB3aXRob3V0IHRoaXMNCj4gcGF0
Y2gsIGFuZCBJIGRvIHNlZSB0aGUgZGF0YSBjb3JydXB0aW9uIGFmdGVyIHJlYm9vdHMuDQo+IA0K
PiBUZXN0ZWQtYnk6IEFydGVtIEJpdHl1dHNraXkgPGFydGVtLmJpdHl1dHNraXlAbGludXguaW50
ZWwuY29tPg0KPiANCj4gQXJ0ZW0uDQoNCkkgY2FuIGNvbmZpcm0gdGhlIHBhdGNoIGZpeGVzIG15
ICJzbG93IHdyaXRlIiBpc3N1ZSB0b28uDQoNClRlc3RlZC1ieTogRGV4dWFuIEN1aSA8ZGVjdWlA
bWljcm9zb2Z0LmNvbT4NCg0KLS0gRGV4dWFuDQo=
