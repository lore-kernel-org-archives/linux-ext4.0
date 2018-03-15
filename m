From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: mmc: block: bonnie++ runs with errors on arc/hsdk board
Date: Thu, 15 Mar 2018 11:27:49 +0200
Message-ID: <83de0f90-0919-f449-b432-494b9bf524a1@intel.com>
References: <1520942674.10285.8.camel@synopsys.com>
 <486fe92e-9b53-53a4-f98d-129a97032470@intel.com>
 <1520956602.10285.10.camel@synopsys.com>
 <1521030769.10285.16.camel@synopsys.com>
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
To: Evgeniy Didin <Evgeniy.Didin@synopsys.com>
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <1521030769.10285.16.camel@synopsys.com>
Content-Language: en-US
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

T24gMTQvMDMvMTggMTQ6MzIsIEV2Z2VuaXkgRGlkaW4gd3JvdGU6Cj4gSGkgQWRyaWFuLAo+Pj4K
Pj4+IFdhcyB0aGUgcGVyZm9ybWFuY2UgYWZmZWN0ZWQ/IGkuZS4gdGhlIHJlc3VsdHMgZnJvbSBi
b25uaWUrKwo+Pgo+PiBJIGhhdmUgcnVuIGJvbm5pZSsrIHNldmVyYWwgdGltZXMgYmVmb3JlIGFu
ZCBhZnRlciBtZW50aW9uZWQgY29tbWl0LiBIZXJlIGlzIG91dHB1dDoKPj4gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS08OC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
Pj4gQmVmb3JlIGNvbW1pdDoKPj4gQVJDTGludXgsNTEyTSw2NDQyLDUwLDcyMTEsMCw1MzMzLDAs
MTI5NTQsOTksMzQ1NjM4LDEwMCwrKysrKywrKyssMTYsMjIzMjIsMTAwLCsrKysrLCsrKywzMjcz
NSw5OSwyMjkyMSwxMDAsKysrKyssKysrLDMyMjExLDEwMAo+PiBBUkNMaW51eCw1MTJNLDY2MTEs
NTEsNzI0OCwwLDUxNjIsMCwxMjk1MSw5OSwzNDQ3NjMsOTksKysrKyssKysrLDE2LDIyNjQ5LDk5
LCsrKysrLCsrKywzMjcyMyw5OSwyMjU3MiwxMDAsKysrKyssKysrLDMxNjk3LDEwMAo+PiBBUkNM
aW51eCw1MTJNLDY1OTcsNTIsNzMwNywwLDUzNjgsMCwxMjkzNCw5OSwzNDM5ODcsOTksKysrKyss
KysrLDE2LDIyNzc1LDEwMCwrKysrKywrKyssMzI3MTMsOTksMjI4MzIsMTAwLCsrKysrLCsrKywz
MTg5OSw5OQo+PiBBZnRlciBjb21taXQ6Cj4+IEFSQ0xpbnV4LDUxMk0sNDQ1MywzNiw2NDc0LDEs
NTg1MiwwLDEyOTQwLDk5LDM0NDMyOSwxMDAsKysrKyssKysrLDE2LDIyMTY4LDk4LCsrKysrLCsr
KywzMjc2MCw5OSwyMjc1NSwxMDAsKysrKyssKysrLDMyMjA1LDEwMAo+PiBBUkNMaW51eCw1MTJN
LDUxNTksNDIsNjk0NCwxLDU2NTgsMCwxMjk0NSw5OSwzNDQyOTAsMTAwLCsrKysrLCsrKywxNiwy
MjI5NSwxMDAsKysrKyssKysrLDMyNzE1LDk5LDIyODg4LDk5LCsrKysrLCsrKywzMjAwNyw5OQo+
PiBBUkNMaW51eCw1MTJNLDUxNzAsNDIsNjg0MCwyLDUzMTUsMCwxMjk0Niw5OSwzNDM4ODksMTAw
LCsrKysrLCsrKywxNiwyMjQ0NSwxMDAsKysrKyssKysrLDMyNjgxLDk5LDIyOTY3LDEwMCwrKysr
KywrKyssMzIxMTcsOTkKPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS08OC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgXl5eXsKgCj4+IElmIGkgdW5kZXJzdGFuZCBjb3JyZWN0bHksIGluIHRoaXJkIGNvbHVtbiBp
cyBzaG93biAic2VxdWVudGlhbCBvdXRwdXQiIHBlciBjaGFyYWN0ZXIgc3BlZWQgKEsvc2VjKSwg
d2hpY2ggZGVjcmVhc2VkLgo+Pgo+Pj4gV2hhdCBtb3VudCBvcHRpb25zIGRpZCB5b3UgdXNlPwo+
Pgo+PiBJIGRpZG4ndCB1c2UgYW55IG9wdGlvbnMuIFNpbXBseToKPj4gIyBtb3VudCAvZGV2L21t
Y2JsazBwMSAvbW50Cj4gCj4gTm90ZSB0aGF0IHRoZSBmaWxlIHN5c3RlbSBvbiBTRGNhcmQgd2Fz
IGV4dDQuwqAKClBsZWFzZSB0cnk6CgoJcGVyZiByZWNvcmQgLWEgLWUgbW1jOiogLS0gYm9ubmll
KysgLXUgcm9vdCAtciAyNTYgLXMgNTEyIC14IDEgLWQgL21udAoKYW5kIHNoYXJlIHRoZSByZXN1
bHRpbmcgcGVyZi5kYXRhIGZpbGUgd2hlbiB5b3UgYXJlIGFibGUKdG8gcmVwcm9kdWNlIHRoZSBo
dW5nIHRhc2sgbWVzc2FnZS4KCllvdSBtYXkgd2FudCB0byBhZGQgdGhpcyBwYXRjaCBmaXJzdDoK
CglodHRwczovL21hcmMuaW5mby8/bD1saW51eC1tbWMmbT0xNTIxMTA1ODAzMjQyMDAKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LXNucHMtYXJj
IG1haWxpbmcgbGlzdApsaW51eC1zbnBzLWFyY0BsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9s
aXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtc25wcy1hcmM=
