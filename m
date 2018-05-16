From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/14] ubifs: separate errno from VM_FAULT_* values
Date: Wed, 16 May 2018 07:43:43 +0200
Message-ID: <20180516054348.15950-10-hch@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, devel@lists.orangefs.org,
 linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, lustre-devel@lists.lustre.org
To: Souptick Joarder <jrdr.linux@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180516054348.15950-1-hch@lst.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
List-Id: linux-ext4.vger.kernel.org

U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0tLQogZnMvdWJp
ZnMvZmlsZS5jIHwgNyArKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3ViaWZzL2ZpbGUuYyBiL2ZzL3ViaWZzL2Zp
bGUuYwppbmRleCAxYWNiMmZmNTA1ZTYuLjdjMWEyZTFjM2RlNSAxMDA2NDQKLS0tIGEvZnMvdWJp
ZnMvZmlsZS5jCisrKyBiL2ZzL3ViaWZzL2ZpbGUuYwpAQCAtMTUxMyw3ICsxNTEzLDcgQEAgc3Rh
dGljIGludCB1Ymlmc19yZWxlYXNlcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSwgZ2ZwX3QgdW51c2Vk
X2dmcF9mbGFncykKICAqIG1tYXAoKWQgZmlsZSBoYXMgdGFrZW4gd3JpdGUgcHJvdGVjdGlvbiBm
YXVsdCBhbmQgaXMgYmVpbmcgbWFkZSB3cml0YWJsZS4KICAqIFVCSUZTIG11c3QgZW5zdXJlIHBh
Z2UgaXMgYnVkZ2V0ZWQgZm9yLgogICovCi1zdGF0aWMgaW50IHViaWZzX3ZtX3BhZ2VfbWt3cml0
ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKK3N0YXRpYyB2bV9mYXVsdF90IHViaWZzX3ZtX3BhZ2Vf
bWt3cml0ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKIHsKIAlzdHJ1Y3QgcGFnZSAqcGFnZSA9IHZt
Zi0+cGFnZTsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9pbm9kZSh2bWYtPnZtYS0+dm1f
ZmlsZSk7CkBAIC0xNTIxLDYgKzE1MjEsNyBAQCBzdGF0aWMgaW50IHViaWZzX3ZtX3BhZ2VfbWt3
cml0ZShzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKIAlzdHJ1Y3QgdGltZXNwZWMgbm93ID0gY3VycmVu
dF90aW1lKGlub2RlKTsKIAlzdHJ1Y3QgdWJpZnNfYnVkZ2V0X3JlcSByZXEgPSB7IC5uZXdfcGFn
ZSA9IDEgfTsKIAlpbnQgZXJyLCB1cGRhdGVfdGltZTsKKwl2bV9mYXVsdF90IHJldCA9IDA7CiAK
IAlkYmdfZ2VuKCJpbm8gJWx1LCBwZyAlbHUsIGlfc2l6ZSAlbGxkIiwJaW5vZGUtPmlfaW5vLCBw
YWdlLT5pbmRleCwKIAkJaV9zaXplX3JlYWQoaW5vZGUpKTsKQEAgLTE2MDEsOCArMTYwMiw4IEBA
IHN0YXRpYyBpbnQgdWJpZnNfdm1fcGFnZV9ta3dyaXRlKHN0cnVjdCB2bV9mYXVsdCAqdm1mKQog
CXVubG9ja19wYWdlKHBhZ2UpOwogCXViaWZzX3JlbGVhc2VfYnVkZ2V0KGMsICZyZXEpOwogCWlm
IChlcnIpCi0JCWVyciA9IFZNX0ZBVUxUX1NJR0JVUzsKLQlyZXR1cm4gZXJyOworCQlyZXQgPSBW
TV9GQVVMVF9TSUdCVVM7CisJcmV0dXJuIHJldDsKIH0KIAogc3RhdGljIGNvbnN0IHN0cnVjdCB2
bV9vcGVyYXRpb25zX3N0cnVjdCB1Ymlmc19maWxlX3ZtX29wcyA9IHsKLS0gCjIuMTcuMAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1h
aWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
