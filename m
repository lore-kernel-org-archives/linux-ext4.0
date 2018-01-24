From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Wed, 24 Jan 2018 12:56:20 +0100
Message-ID: <CAK8P3a2+WO70nUW4xAAW-Lmc9OzcjERhKm8zZiBTcscKWzocdg@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com>
 <20180122020426.2988-4-deepa.kernel@gmail.com>
 <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
 <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, y2038 Mailman List <y2038@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CABeXuvogBWfTzteb8RFAGnW_HGLQX=hVUj0_SZ-TP1ZeNj=OHA@mail.gmail.com>
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

T24gVHVlLCBKYW4gMjMsIDIwMTggYXQgNToyNSBQTSwgRGVlcGEgRGluYW1hbmkgPGRlZXBhLmtl
cm5lbEBnbWFpbC5jb20+IHdyb3RlOgo+IE9uIE1vbiwgSmFuIDIyLCAyMDE4IGF0IDEyOjI1IFBN
LCBMaW51cyBUb3J2YWxkcwo+IDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6
Cj4+IE9uIFN1biwgSmFuIDIxLCAyMDE4IGF0IDY6MDQgUE0sIERlZXBhIERpbmFtYW5pIDxkZWVw
YS5rZXJuZWxAZ21haWwuY29tPiB3cm90ZToKPj4+ICsgICAgICAgICAgICAgICB0LnR2X25zZWMg
LT0gdC50dl9uc2VjICUgZ3JhbjsKPj4KPj4gVGhpcyBkb2Vzbid0IGFjdHVhbGwgeXdvcmsgaWYg
dHZfbnNlYyBpcyBuZWdhdGl2ZS4KPgo+IFJpZ2h0Lgo+Cj4+IFdoaWNoIG1heSBub3QgYmUgYW4g
aXNzdWUgaW4gbW9zdCBjYXNlcywgYnV0IGRpZCBzb21lYm9keSBjaGVjawo+PiB1dGltZW5zYXQo
KSBvciB3aGF0ZXZlcj8KPgo+IEkgY2hlY2tlZCBQT1NJWCBhZ2Fpbi4gVGhlcmUgaXMgbm8gbWVu
dGlvbiBvZiB0dl9uc2VjIGJlaW5nIHBvc2l0aXZlCj4gYWx3YXlzIGZvciB1dGltZXMuCj4gQW5k
LCB0aGUgbG9uZyB0ZXJtIHBsYW4gaXMgdG8gcmVwbGFjZSBhbGwgdGhlIGNhbGxlcnMgb2YKPiB0
aW1lc3BlY190cnVuYygpIHRvIHVzZSB0aGlzIG5ldyBhcGkgaW5zdGVhZCBmb3IgZmlsZXN5c3Rl
bXMuCj4gU28gdGhpcyB3aWxsIG5lZWQgdG8gYmUgZml4ZWQuIEkgd2lsbCBmaXggdGhpcyBhbmQg
cG9zdCBhbiB1cGRhdGUuCgpJIGZvdW5kIHRoaXMgb24KaHR0cDovL3B1YnMub3Blbmdyb3VwLm9y
Zy9vbmxpbmVwdWJzLzk2OTk5MTk3OTkvZnVuY3Rpb25zL3V0aW1lcy5odG1sCgpFUlJPUlMKVGhl
c2UgZnVuY3Rpb25zIHNoYWxsIGZhaWwgaWY6Ci4uLgpbRUlOVkFMXQogRWl0aGVyIG9mIHRoZSB0
aW1lcyBhcmd1bWVudCBzdHJ1Y3R1cmVzIHNwZWNpZmllZCBhIHR2X25zZWMgdmFsdWUgdGhhdCB3
YXMKIG5laXRoZXIgVVRJTUVfTk9XIG5vciBVVElNRV9PTUlULCBhbmQgd2FzIGEgdmFsdWUgbGVz
cyB0aGFuIHplcm8gb3IKIGdyZWF0ZXIgdGhhbiBvciBlcXVhbCB0byAxMDAwIG1pbGxpb24uCgp3
aGljaCBpcyB0aGUgc2FtZSBhcyB0aGUgTGludXggbWFuIHBhZ2UgYW5kIHdoYXQgdGhlIGtlcm5l
bCBhY3R1YWxseQpkb2VzIGZvciBhbGwgdGhlIHN5c2NhbGxzLiBUaGUgUE9TSVggZGVzY3JpcHRp
b24gc2VlbXMgYSBiaXQgYW1iaWd1b3VzCnRvIHdoZXRoZXIgaXQgYWxzbyBleHBlY3RzIG9yIGFs
bG93cyBFSU5WQUwgZm9yIHV0aW1lcygpIHdpdGggYSB0dl91c2VjCm92ZXIgMTAwMDAwMCBtaWNy
b3NlY29uZHMsIG9yIGlmIGl0IGp1c3QgYXBwbGllcyB0byB0aGUgdXRpbWVuc2F0IGFuZApmdXRp
bWVucygpLiBPbGRlciBkZXNjcmlwdGlvbnMgdGhhdCBvbmx5IGV4cGxhaW4gdXRpbWVzKCkgZG9u
J3QgbWVudGlvbgp0aGUgcmFuZ2UgY2hlY2sgb24gdHZfdXNlYyBlaXRoZXIuCgogICAgICAgICAg
QXJuZApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAz
OCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFy
by5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
