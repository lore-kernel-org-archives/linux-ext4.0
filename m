From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/6] ext4: use ktime_get_real_seconds for i_dtime
Date: Thu, 21 Jun 2018 22:07:47 +0200
Message-ID: <CAK8P3a1VzHpyighcfvSsG-Zfq2s7nURXcE6AdXamP7mO5C2q7Q@mail.gmail.com>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-3-arnd@arndb.de>
 <F6095896-5B1A-4A20-9293-086A9350F75C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
 y2038 Mailman List <y2038@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>,
 Miao Xie <miaoxie@huawei.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <F6095896-5B1A-4A20-9293-086A9350F75C@dilger.ca>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
List-Id: linux-ext4.vger.kernel.org

T24gVGh1LCBKdW4gMjEsIDIwMTggYXQgNzoyNyBQTSwgQW5kcmVhcyBEaWxnZXIgPGFkaWxnZXJA
ZGlsZ2VyLmNhPiB3cm90ZToKPiBPbiBKdW4gMjAsIDIwMTgsIGF0IDk6MzMgQU0sIEFybmQgQmVy
Z21hbm4gPGFybmRAYXJuZGIuZGU+IHdyb3RlOgo+Pgo+PiBXZSBvbmx5IGNhcmUgYWJvdXQgdGhl
IGxvdyAzMi1iaXQgZm9yIGlfZHRpbWUgYXMgZXhwbGFpbmVkIGluIGNvbW1pdAo+PiBiNWY1MTU3
MzViZWEgKCJleHQ0OiBhdm9pZCBZMjAzOCBvdmVyZmxvdyBpbiByZWNlbnRseV9kZWxldGVkKCki
KSwgc28KPj4gdGhlIHVzZSBvZiBnZXRfc2Vjb25kcygpIGlzIGNvcnJlY3QgaGVyZSwgYnV0IHRo
YXQgZnVuY3Rpb24gaXMgZ2V0dGluZwo+PiByZW1vdmVkIGluIHRoZSBwcm9jZXNzIG9mIHRoZSB5
MjAzOCBmaXhlcywgc28gbGV0J3MgdXNlIHRoZSBtb2Rlcm4KPj4ga3RpbWVfZ2V0X3JlYWxfc2Vj
b25kcygpIGhlcmUuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJu
ZGIuZGU+Cj4KPiBMb29rcyBPSywgb25lIG1pbm9yIGNsZWFudXAgcG9zc2libGUuCj4KPiBSZXZp
ZXdlZC1ieTogQW5kcmVhcyBEaWxnZXIgPGFkaWxnZXJAZGlsZ2VyLmNhPgo+PiAgICAgICBleHQ0
X29ycGhhbl9kZWwoaGFuZGxlLCBpbm9kZSk7Cj4+IC0gICAgIEVYVDRfSShpbm9kZSktPmlfZHRp
bWUgID0gZ2V0X3NlY29uZHMoKTsKPj4gKyAgICAgRVhUNF9JKGlub2RlKS0+aV9kdGltZSAgPSBr
dGltZV9nZXRfcmVhbF9zZWNvbmRzKCk7Cj4KPiBOb3Qgc3RyaWN0bHkgbmVjZXNzYXJ5LCBidXQg
aXQgbWlnaHQgYmUgZ29vZCBmcm9tIGEgY29kZSBjbGFyaXR5IFBPVgo+IHRvIHVzZToKPgo+ICAg
ICAgICAgRVhUNF9JKGlub2RlKS0+aV9kdGltZSAgPSAoX191MzIpa3RpbWVfZ2V0X3JlYWxfc2Vj
b25kcygpOwo+Cj4gc28gdGhhdCBpdCBpcyBtb3JlIGNsZWFyIHdlIGFyZSBhd2FyZSB0aGF0IHRo
aXMgaXMgYmVpbmcgdHJ1bmNhdGVkCj4gdG8gYSAzMi1iaXQgdmFsdWUuCgpSaWdodCwgSSd2ZSBi
ZWVuIGEgYml0IGluY29uc2lzdGVudCBoZXJlIGFjcm9zcyBmaWxlIHN5c3RlbXMsIEkndmUKZG9u
ZSB0aGlzIGluIHNvbWUgb3RoZXIgb25lcywgdXNpbmcgZWl0aGVyIGEgY2FzdCBvciBhIGxvd2Vy
XzMyX2JpdHMoKQpmdW5jdGlvbiBjYWxsLiBDaGFuZ2VkIGl0IGFzIHlvdSBzdWdnZXN0ZWQgaGVy
ZSBub3cuCgogICAgIEFybmQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6
Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
