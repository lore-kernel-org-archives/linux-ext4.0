From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 1/3] ext4: fix setattr project check upon
 fssetxattr ioctl
Date: Sun, 16 Sep 2018 08:20:34 -0400
Message-ID: <20180916122034.GA5915@thunk.org>
References: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
 <20180916035529.GG8652@thunk.org>
 <75832A38-2476-4504-A03C-15B40053A565@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "adilger@dilger.ca" <adilger@dilger.ca>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Wang Shilong <wangshilong1991@gmail.com>,
 "dchinner@redhat.com" <dchinner@redhat.com>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>
To: Wang Shilong <wshilong@ddn.com>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <75832A38-2476-4504-A03C-15B40053A565@ddn.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

T24gU3VuLCBTZXAgMTYsIDIwMTggYXQgMDQ6MDI6NTJBTSArMDAwMCwgV2FuZyBTaGlsb25nIHdy
b3RlOgo+IAo+IAo+ID4g5ZyoIDIwMTjlubQ55pyIMTbml6XvvIzkuIrljYgxMTo1Ne+8jFRoZW9k
b3JlIFkuIFRzJ28gPHR5dHNvQG1pdC5lZHU+IOWGmemBk++8mgo+ID4gCj4gPiBPbiBXZWQsIFNl
cCAxMiwgMjAxOCBhdCAwODo1NzoxNkFNICswOTAwLCBXYW5nIFNoaWxvbmcgd3JvdGU6Cj4gPj4g
ZGlmZiAtLWdpdCBhL2ZzL2V4dDQvaW9jdGwuYyBiL2ZzL2V4dDQvaW9jdGwuYwo+ID4+IGluZGV4
IGE3MDc0MTE1ZDZmNi4uZjgxMTAyYmQzMjAzIDEwMDY0NAo+ID4+IC0tLSBhL2ZzL2V4dDQvaW9j
dGwuYwo+ID4+ICsrKyBiL2ZzL2V4dDQvaW9jdGwuYwo+ID4+IEBAIC0zMzksMTkgKzMzOSwxNCBA
QCBzdGF0aWMgaW50IGV4dDRfaW9jdGxfc2V0cHJvamVjdChzdHJ1Y3QgZmlsZSAqZmlscCwgX191
MzIgcHJvamlkKQo+ID4+IAlpZiAocHJvamlkX2VxKGtwcm9qaWQsIEVYVDRfSShpbm9kZSktPmlf
cHJvamlkKSkKPiA+PiAJCXJldHVybiAwOwo+ID4+IAo+ID4+IC0JZXJyID0gbW50X3dhbnRfd3Jp
dGVfZmlsZShmaWxwKTsKPiA+PiAtCWlmIChlcnIpCj4gPj4gLQkJcmV0dXJuIGVycjsKPiA+PiAt
Cj4gPiAKPiA+IEEgaHVnZSBwYXJ0IG9mIHRoaXMgcGF0Y2ggaXMgZHJvcHBpbmcgdGhlIGNhbGxz
IHRvCj4gPiBtbnRfd2FudF93cml0ZV9maWxlKCkgYW5kIG1udF9kcm9wX3dyaXRlX2ZpbGUoKS4g
IFdoYXQncyB0aGUKPiA+IGp1c3RpZmljYXRpb24gZm9yIGRvaW5nIHRoaXM/ICBUaGUgdXNlIG9m
IG1udF93YW50X3dyaXRlX2ZpbGUoKSBsb29rcwo+ID4gbmVjZXNzYXJ5IHRvIG1l4oCmCj4gCj4g
SGkgVGVkLAo+IAo+ICAgICAgbW50X3dhbnRfd3JpdGVfZmlsZSgpIGFuZCBpbm9kZV9sb2NrIGlz
IGhlbGQgYmVmb3JlIHRoaXMgZnVuY3Rpb24gY2FsbGVkIG5vdy4KPiBTaW5jZSBib3RoIGlvY3Rs
X3NldF9mbGFncyBhbmQgZXh0NF9zZXRfcHJvamVjdCgpIG5lZWQgY2FsbCB0aGVtLgoKSSBkb24n
dCBzZWUgYW55IHBsYWNlIGluIHRoaXMgcGF0Y2ggd2hlcmUgbW50X3dhbnRfd3JpdGVfZmlsZSgp
IGlzCmJlaW5nIGNhbGxlZC4gIFdoYXQgYW0gSSBtaXNzaW5nPyAgQW5kIGlmIHRoZXJlIGlzIGEg
ZGVwZW5kZW50IHBhdGNoCnRvIHRoaXMgZmlyc3QgcGF0Y2ggaW4gdGhlIHBhdGNoIHNlcmllcywg
cGxlYXNlIGluY2x1ZGUgaXQgaW4gdGhpcwpwYXRjaCBzZXJpZXMuLi4uICBvciBsZWFzdCBwb2lu
dCBpdCBvdXQgYWZ0ZXIgdGhlIC0tLSBsaXN0LgoKVGhhbmtzLAoKCQkJCQkJLSBUZWQKCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1mMmZzLWRl
dmVsIG1haWxpbmcgbGlzdApMaW51eC1mMmZzLWRldmVsQGxpc3RzLnNvdXJjZWZvcmdlLm5ldApo
dHRwczovL2xpc3RzLnNvdXJjZWZvcmdlLm5ldC9saXN0cy9saXN0aW5mby9saW51eC1mMmZzLWRl
dmVsCg==
