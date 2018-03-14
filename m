From: Evgeniy Didin <Evgeniy.Didin@synopsys.com>
Subject: Re: mmc: block: bonnie++ runs with errors on arc/hsdk board
Date: Wed, 14 Mar 2018 12:32:50 +0000
Message-ID: <1521030769.10285.16.camel@synopsys.com>
References: <1520942674.10285.8.camel@synopsys.com>
 <486fe92e-9b53-53a4-f98d-129a97032470@intel.com>
 <1520956602.10285.10.camel@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "tytso@mit.edu" <tytso@mit.edu>,
 "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
 "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
 "linux-snps-arc@lists.infradead.org" <linux-snps-arc@lists.infradead.org>,
 "Eugeniy.Paltsev@synopsys.com" <Eugeniy.Paltsev@synopsys.com>
To: "adrian.hunter@intel.com" <adrian.hunter@intel.com>
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <1520956602.10285.10.camel@synopsys.com>
Content-Language: en-US
Content-ID: <FE7645740806C74AA8847536493B0757@internal.synopsys.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

SGkgQWRyaWFuLA0KPiA+IA0KPiA+IFdhcyB0aGUgcGVyZm9ybWFuY2UgYWZmZWN0ZWQ/IGkuZS4g
dGhlIHJlc3VsdHMgZnJvbSBib25uaWUrKw0KPiANCj4gSSBoYXZlIHJ1biBib25uaWUrKyBzZXZl
cmFsIHRpbWVzIGJlZm9yZSBhbmQgYWZ0ZXIgbWVudGlvbmVkIGNvbW1pdC4gSGVyZSBpcyBvdXRw
dXQ6DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
PDgtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQo+IEJlZm9yZSBjb21taXQ6DQo+IEFSQ0xpbnV4LDUxMk0sNjQ0
Miw1MCw3MjExLDAsNTMzMywwLDEyOTU0LDk5LDM0NTYzOCwxMDAsKysrKyssKysrLDE2LDIyMzIy
LDEwMCwrKysrKywrKyssMzI3MzUsOTksMjI5MjEsMTAwLCsrKysrLCsrKywzMjIxMSwxMDANCj4g
QVJDTGludXgsNTEyTSw2NjExLDUxLDcyNDgsMCw1MTYyLDAsMTI5NTEsOTksMzQ0NzYzLDk5LCsr
KysrLCsrKywxNiwyMjY0OSw5OSwrKysrKywrKyssMzI3MjMsOTksMjI1NzIsMTAwLCsrKysrLCsr
KywzMTY5NywxMDANCj4gQVJDTGludXgsNTEyTSw2NTk3LDUyLDczMDcsMCw1MzY4LDAsMTI5MzQs
OTksMzQzOTg3LDk5LCsrKysrLCsrKywxNiwyMjc3NSwxMDAsKysrKyssKysrLDMyNzEzLDk5LDIy
ODMyLDEwMCwrKysrKywrKyssMzE4OTksOTkNCj4gQWZ0ZXIgY29tbWl0Og0KPiBBUkNMaW51eCw1
MTJNLDQ0NTMsMzYsNjQ3NCwxLDU4NTIsMCwxMjk0MCw5OSwzNDQzMjksMTAwLCsrKysrLCsrKywx
NiwyMjE2OCw5OCwrKysrKywrKyssMzI3NjAsOTksMjI3NTUsMTAwLCsrKysrLCsrKywzMjIwNSwx
MDANCj4gQVJDTGludXgsNTEyTSw1MTU5LDQyLDY5NDQsMSw1NjU4LDAsMTI5NDUsOTksMzQ0Mjkw
LDEwMCwrKysrKywrKyssMTYsMjIyOTUsMTAwLCsrKysrLCsrKywzMjcxNSw5OSwyMjg4OCw5OSwr
KysrKywrKyssMzIwMDcsOTkNCj4gQVJDTGludXgsNTEyTSw1MTcwLDQyLDY4NDAsMiw1MzE1LDAs
MTI5NDYsOTksMzQzODg5LDEwMCwrKysrKywrKyssMTYsMjI0NDUsMTAwLCsrKysrLCsrKywzMjY4
MSw5OSwyMjk2NywxMDAsKysrKyssKysrLDMyMTE3LDk5DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tPDgtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoF5eXl7CoA0KPiBJZiBpIHVuZGVyc3RhbmQgY29ycmVjdGx5
LCBpbiB0aGlyZCBjb2x1bW4gaXMgc2hvd24gInNlcXVlbnRpYWwgb3V0cHV0IiBwZXIgY2hhcmFj
dGVyIHNwZWVkIChLL3NlYyksIHdoaWNoIGRlY3JlYXNlZC4NCj4gDQo+ID4gV2hhdCBtb3VudCBv
cHRpb25zIGRpZCB5b3UgdXNlPw0KPiANCj4gSSBkaWRuJ3QgdXNlIGFueSBvcHRpb25zLiBTaW1w
bHk6DQo+ICMgbW91bnQgL2Rldi9tbWNibGswcDEgL21udA0KDQpOb3RlIHRoYXQgdGhlIGZpbGUg
c3lzdGVtIG9uIFNEY2FyZCB3YXMgZXh0NC7CoA0KDQpCZXN0IHJlZ2FyZHMsDQpFdmdlbml5IERp
ZGluCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4
LXNucHMtYXJjIG1haWxpbmcgbGlzdApsaW51eC1zbnBzLWFyY0BsaXN0cy5pbmZyYWRlYWQub3Jn
Cmh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtc25wcy1h
cmM=
