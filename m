From: cgxu519 <cgxu519@gmx.com>
Subject: Re: [PATCH v2 2/5] ext4: cache NULL when both
 default_acl and acl are NULL
Date: Wed, 12 Sep 2018 23:04:35 +0800
Message-ID: <f1dd02a3-78ea-0240-72cc-135ee26f6524@gmx.com>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-2-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net,
 martin@omnibond.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, jack@suse.com, jaegeuk@kernel.org,
 linux-ext4@vger.kernel.org, devel@lists.orangefs.org, hubcap@omnibond.com
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180831143352.22970-2-cgxu519@gmx.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

T24gMDgvMzEvMjAxOCAxMDozMyBQTSwgQ2hlbmdndWFuZyBYdSB3cm90ZToKPiBkZWZhdWx0X2Fj
bCBhbmQgYWNsIG9mIG5ld2x5IGNyZWF0ZWQgaW5vZGUgd2lsbCBiZSBpbml0aWF0ZWQKPiBhcyBB
Q0xfTk9UX0NBQ0hFRCBpbiB2ZnMgZnVuY3Rpb24gaW5vZGVfaW5pdF9hbHdheXMoKSBhbmQgbGF0
ZXIKPiB3aWxsIGJlIHVwZGF0ZWQgYnkgY2FsbGluZyB4eHhfaW5pdF9hY2woKSBpbiBzcGVjaWZp
YyBmaWxlc3lzdGVtcy4KPiBIb3dlcnZlciwgd2hlbiBkZWZhdWx0X2FjbCBhbmQgYWNsIGFyZSBO
VUxMIHRoZW4gdGhleSBrZWVwIHRoZSB2YWx1ZQo+IG9mIEFDTF9OT1RfQ0FDSEVELCB0aGlzIHBh
dGNoIHRyaWVzIHRvIGNhY2hlIE5VTEwgZm9yIGFjbC9kZWZhdWx0X2FjbAo+IGluIHRoaXMgY2Fz
ZS4KPgo+IFNpZ25lZC1vZmYtYnk6IENoZW5nZ3VhbmcgWHUgPGNneHU1MTlAZ214LmNvbT4KPiAt
LS0KPiB2MS0+djI6Cj4gLSBDb2Rpbmcgc3R5bGUgY2hhbmdlLgo+Cj4gICBmcy9leHQ0L2FjbC5j
IHwgNCArKysrCj4gICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCj4KPiBkaWZmIC0t
Z2l0IGEvZnMvZXh0NC9hY2wuYyBiL2ZzL2V4dDQvYWNsLmMKPiBpbmRleCBmYjUwZjlhYTZlYWQu
LmMxZDU3MGVlMWQ5ZiAxMDA2NDQKPiAtLS0gYS9mcy9leHQ0L2FjbC5jCj4gKysrIGIvZnMvZXh0
NC9hY2wuYwo+IEBAIC0yODQsMTIgKzI4NCwxNiBAQCBleHQ0X2luaXRfYWNsKGhhbmRsZV90ICpo
YW5kbGUsIHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBpbm9kZSAqZGlyKQo+ICAgCQllcnJv
ciA9IF9fZXh0NF9zZXRfYWNsKGhhbmRsZSwgaW5vZGUsIEFDTF9UWVBFX0RFRkFVTFQsCj4gICAJ
CQkJICAgICAgIGRlZmF1bHRfYWNsLCBYQVRUUl9DUkVBVEUpOwo+ICAgCQlwb3NpeF9hY2xfcmVs
ZWFzZShkZWZhdWx0X2FjbCk7Cj4gKwl9IGVsc2Ugewo+ICsJCWlub2RlLT5pX2RlZmF1bHRfYWNs
ID0gTlVMTDsKPiAgIAl9Cj4gICAJaWYgKGFjbCkgewo+ICAgCQlpZiAoIWVycm9yKQo+ICAgCQkJ
ZXJyb3IgPSBfX2V4dDRfc2V0X2FjbChoYW5kbGUsIGlub2RlLCBBQ0xfVFlQRV9BQ0NFU1MsCj4g
ICAJCQkJCSAgICAgICBhY2wsIFhBVFRSX0NSRUFURSk7Cj4gICAJCXBvc2l4X2FjbF9yZWxlYXNl
KGFjbCk7Cj4gKwl9IGVsc2Ugewo+ICsJCWlub2RlLT5pX2FjbCA9IE5VTEw7Cj4gICAJfQo+ICAg
CXJldHVybiBlcnJvcjsKPiAgIH0KCkhpIFRlZCzCoCBBbmRyZWFzCgpIYXZlIHlvdSBnb3QgY2hh
bmNlIHRvIGxvb2sgYXQgdGhpcyBwYXRjaD8KClRoYW5rcywKQ2hlbmdndWFuZwoKCgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtZjJmcy1kZXZl
bCBtYWlsaW5nIGxpc3QKTGludXgtZjJmcy1kZXZlbEBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQKaHR0
cHM6Ly9saXN0cy5zb3VyY2Vmb3JnZS5uZXQvbGlzdHMvbGlzdGluZm8vbGludXgtZjJmcy1kZXZl
bAo=
