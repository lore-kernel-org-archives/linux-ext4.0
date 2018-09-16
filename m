From: Wang Shilong <wshilong@ddn.com>
Subject: Re: [PATCH v3 1/3] ext4: fix setattr project check upon
 fssetxattr ioctl
Date: Sun, 16 Sep 2018 04:02:52 +0000
Message-ID: <75832A38-2476-4504-A03C-15B40053A565@ddn.com>
References: <1536710238-16858-1-git-send-email-wshilong1991@gmail.com>
 <20180916035529.GG8652@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Cc: "adilger@dilger.ca" <adilger@dilger.ca>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Wang Shilong <wangshilong1991@gmail.com>,
 "dchinner@redhat.com" <dchinner@redhat.com>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180916035529.GG8652@thunk.org>
Content-Language: en-US
Content-ID: <388CC3318E768D4B9B1CA20A73A5D0A1@ddn.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

DQoNCj4g1NogMjAxOMTqOdTCMTbI1aOsyc/O5zExOjU1o6xUaGVvZG9yZSBZLiBUcydvIDx0eXRz
b0BtaXQuZWR1PiDQtLXAo7oNCj4gDQo+IE9uIFdlZCwgU2VwIDEyLCAyMDE4IGF0IDA4OjU3OjE2
QU0gKzA5MDAsIFdhbmcgU2hpbG9uZyB3cm90ZToNCj4+IGRpZmYgLS1naXQgYS9mcy9leHQ0L2lv
Y3RsLmMgYi9mcy9leHQ0L2lvY3RsLmMNCj4+IGluZGV4IGE3MDc0MTE1ZDZmNi4uZjgxMTAyYmQz
MjAzIDEwMDY0NA0KPj4gLS0tIGEvZnMvZXh0NC9pb2N0bC5jDQo+PiArKysgYi9mcy9leHQ0L2lv
Y3RsLmMNCj4+IEBAIC0zMzksMTkgKzMzOSwxNCBAQCBzdGF0aWMgaW50IGV4dDRfaW9jdGxfc2V0
cHJvamVjdChzdHJ1Y3QgZmlsZSAqZmlscCwgX191MzIgcHJvamlkKQ0KPj4gCWlmIChwcm9qaWRf
ZXEoa3Byb2ppZCwgRVhUNF9JKGlub2RlKS0+aV9wcm9qaWQpKQ0KPj4gCQlyZXR1cm4gMDsNCj4+
IA0KPj4gLQllcnIgPSBtbnRfd2FudF93cml0ZV9maWxlKGZpbHApOw0KPj4gLQlpZiAoZXJyKQ0K
Pj4gLQkJcmV0dXJuIGVycjsNCj4+IC0NCj4gDQo+IEEgaHVnZSBwYXJ0IG9mIHRoaXMgcGF0Y2gg
aXMgZHJvcHBpbmcgdGhlIGNhbGxzIHRvDQo+IG1udF93YW50X3dyaXRlX2ZpbGUoKSBhbmQgbW50
X2Ryb3Bfd3JpdGVfZmlsZSgpLiAgV2hhdCdzIHRoZQ0KPiBqdXN0aWZpY2F0aW9uIGZvciBkb2lu
ZyB0aGlzPyAgVGhlIHVzZSBvZiBtbnRfd2FudF93cml0ZV9maWxlKCkgbG9va3MNCj4gbmVjZXNz
YXJ5IHRvIG1loa0NCg0KSGkgVGVkLA0KDQogICAgIG1udF93YW50X3dyaXRlX2ZpbGUoKSBhbmQg
aW5vZGVfbG9jayBpcyBoZWxkIGJlZm9yZSB0aGlzIGZ1bmN0aW9uIGNhbGxlZCBub3cuDQpTaW5j
ZSBib3RoIGlvY3RsX3NldF9mbGFncyBhbmQgZXh0NF9zZXRfcHJvamVjdCgpIG5lZWQgY2FsbCB0
aGVtLg0KDQoNCj4gDQo+IAkJCQktIFRlZA0KDQoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KTGludXgtZjJmcy1kZXZlbCBtYWlsaW5nIGxpc3QKTGludXgt
ZjJmcy1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQKaHR0cHM6Ly9saXN0cy5zb3VyY2Vmb3Jn
ZS5uZXQvbGlzdHMvbGlzdGluZm8vbGludXgtZjJmcy1kZXZlbAo=
