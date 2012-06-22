From: "Luca Porzio (lporzio)" <lporzio@micron.com>
Subject: RE: [PATCH 2/3] ext4: Context support
Date: Fri, 22 Jun 2012 14:07:29 +0000
Message-ID: <26E7A31274623843B0E8CF86148BFE32779DA704@NTXAVZMBX04.azit.micron.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	 <201206122007.28514.arnd.bergmann@linaro.org>
	 <20120612204128.GF12161@thunk.org>
	 <201206131944.35351.arnd.bergmann@linaro.org>
 <1340371753.3363.7.camel@koala>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Saugata Das <saugata.das@stericsson.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"patches@linaro.org" <patches@linaro.org>,
	"venkat@linaro.org" <venkat@linaro.org>
To: Artem Bityutskiy <dedekind1@gmail.com>,
	Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1340371753.3363.7.camel@koala>
Content-Language: en-US
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

SGFsbG8sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtbW1j
LW93bmVyQHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOmxpbnV4LW1tYy1vd25lckB2Z2VyLmtlcm5l
bC5vcmddDQo+IE9uIEJlaGFsZiBPZiBBcnRlbSBCaXR5dXRza2l5DQo+IFNlbnQ6IEZyaWRheSwg
SnVuZSAyMiwgMjAxMiAzOjI5IFBNDQo+IFRvOiBBcm5kIEJlcmdtYW5uDQo+IENjOiBUZWQgVHMn
bzsgQWxleCBMZW1iZXJnOyBIWU9KSU4gSkVPTkc7IFNhdWdhdGEgRGFzOyBTYXVnYXRhIERhczsg
bGludXgtDQo+IGV4dDRAdmdlci5rZXJuZWwub3JnOyBsaW51eC1mc2RldmVsQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtDQo+IG1tY0B2Z2VyLmtlcm5lbC5vcmc7IHBhdGNoZXNAbGluYXJvLm9yZzsg
dmVua2F0QGxpbmFyby5vcmc7IEx1Y2EgUG9yemlvDQo+IChscG9yemlvKQ0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIDIvM10gZXh0NDogQ29udGV4dCBzdXBwb3J0DQo+IA0KPiBPbiBXZWQsIDIwMTIt
MDYtMTMgYXQgMTk6NDQgKzAwMDAsIEFybmQgQmVyZ21hbm4gd3JvdGU6DQo+ID4gSSB0aGluayB1
c2luZyB0aGUgaW5vZGUgbnVtYmVyIGlzIGEgcmVhc29uYWJsZSBmaXQuIFVzaW5nIHRoZSBpbm9k
ZQ0KPiA+IG51bWJlciBvZiB0aGUgcGFyZW50IGRpcmVjdG9yeSBtaWdodCBiZSBtb3JlIGFwcHJv
cHJpYXRlIGJ1dCBpdCBicmVha3MNCj4gPiB3aXRoIGhhcmQgbGlua3MgYW5kIGNyb3NzLWRpcmVj
dG9yeSByZW5hbWVzICh3ZSBtdXN0IG5vdCB1c2UgdGhlIHNhbWUNCj4gPiBMQkEgd2l0aCBjb25m
bGljdGluZyBjb250ZXh0IG51bWJlcnMsIG9yIGZsdXNoIHRoZSBvbGQgY29udGV4dA0KPiA+IGlu
YmV0d2VlbikuDQo+IA0KPiBJIHdvdWxkIHB1dCBpdCB0aGlzIHdheS4NCj4gDQo+IDEuIGNvbnRl
eCA9IGlub2RlIG51bWJlciBmb3IgZGF0YSBibG9ja3MuDQo+IDIuIGNvbnRleHQgPSBwYXJlbnQg
ZGlyZWN0b3J5J3MgaW5vZGUgbnVtYmVyIGZvciBzdGF0IGRhdGEgKHRpbWVzLA0KPiBwZXJtaXNz
aW9ucywgZXRjKSBibG9ja3MgYW5kIGRpcmVjdG9yeSBlbnRyeSBibG9ja3MuIFNob3VsZCBoZWxw
IHRoaW5ncyBsaWtlDQo+IHJlYWRkaXIgYW5kIHJlYWRkaXIgKyBzdGF0LiBCZXNpZGVzLCB0aGlz
IHN0dWZmIHRlbmQgdG8gY2hhbmdlIG1vcmUgb2Z0ZW4gdGhhbg0KPiB0aGUgZGF0YSwgc28gbWl4
aW5nIGl0IHdpdGggdGhlIGRhdGEgaW4gdGhlIHNhbWUgZXJhc2VibG9jayBpcyBub3Qgc21hcnQu
DQo+IDMuIGNvbnRleHQgPSBwYXJlbnQgaW5vZGUgbnVtYmVyIGZvciBhbGwgdGhlIHN0dWZmIGJl
bG9uZ2luZyB0byB4YXR0cnMuDQo+IA0KPiBXZSBkbyBzb21ldGhpbmcgc2ltaWxhciBpbiBVQklG
Uy4NCj4gDQoNCkRvZXNuJ3QgdGhpcyBlbmQgdXAgdXNpbmcgdG9vIG1hbnkgY29udGV4dHM/DQpP
cGVuaW5nIG9uZSBjb250ZXh0cyBwZXIgaW5vZGUgd291bGQgZW5kIHVwIGluIG9wZW5pbmcgbW9y
ZSBjb250ZXh0cyB0aGFuIGF2YWlsYWJsZS4NClRoZSBlTU1DIHNwZWMgZm9yYmlkcyBtb3JlIHRo
YW4gMTUgY29udGV4dHMgZm9yIHRoZSB3aG9sZSBkZXZpY2UuDQoNCj4gLS0NCj4gQmVzdCBSZWdh
cmRzLA0KPiBBcnRlbSBCaXR5dXRza2l5DQoNCkNoZWVycywNCiAgICBMdWNhDQo=
