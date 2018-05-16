From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] orangefs: don't return errno values from ->fault
Date: Wed, 16 May 2018 07:43:35 +0200
Message-ID: <20180516054348.15950-2-hch@lst.de>
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

U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0tLQogZnMvb3Jh
bmdlZnMvZmlsZS5jIHwgMTAgKysrKy0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9vcmFuZ2Vmcy9maWxlLmMgYi9m
cy9vcmFuZ2Vmcy9maWxlLmMKaW5kZXggMjYzNThlZmJmNzk0Li5iNGEyNWNkNGYzZmEgMTAwNjQ0
Ci0tLSBhL2ZzL29yYW5nZWZzL2ZpbGUuYworKysgYi9mcy9vcmFuZ2Vmcy9maWxlLmMKQEAgLTUy
OCwxOCArNTI4LDE2IEBAIHN0YXRpYyBsb25nIG9yYW5nZWZzX2lvY3RsKHN0cnVjdCBmaWxlICpm
aWxlLCB1bnNpZ25lZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFyCiAJcmV0dXJuIHJldDsKIH0K
IAotc3RhdGljIGludCBvcmFuZ2Vmc19mYXVsdChzdHJ1Y3Qgdm1fZmF1bHQgKnZtZikKK3N0YXRp
YyB2bV9mYXVsdF90IG9yYW5nZWZzX2ZhdWx0KHN0cnVjdCB2bV9mYXVsdCAqdm1mKQogewogCXN0
cnVjdCBmaWxlICpmaWxlID0gdm1mLT52bWEtPnZtX2ZpbGU7CiAJaW50IHJjOwotCXJjID0gb3Jh
bmdlZnNfaW5vZGVfZ2V0YXR0cihmaWxlLT5mX21hcHBpbmctPmhvc3QsIDAsIDEsCi0JICAgIFNU
QVRYX1NJWkUpOwotCWlmIChyYyA9PSAtRVNUQUxFKQotCQlyYyA9IC1FSU87CisKKwlyYyA9IG9y
YW5nZWZzX2lub2RlX2dldGF0dHIoZmlsZS0+Zl9tYXBwaW5nLT5ob3N0LCAwLCAxLCBTVEFUWF9T
SVpFKTsKIAlpZiAocmMpIHsKIAkJZ29zc2lwX2VycigiJXM6IG9yYW5nZWZzX2lub2RlX2dldGF0
dHIgZmFpbGVkLCAiCiAJCSAgICAicmM6JWQ6LlxuIiwgX19mdW5jX18sIHJjKTsKLQkJcmV0dXJu
IHJjOworCQlyZXR1cm4gVk1fRkFVTFRfU0lHQlVTOwogCX0KIAlyZXR1cm4gZmlsZW1hcF9mYXVs
dCh2bWYpOwogfQotLSAKMi4xNy4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVl
ZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5m
by9kcmktZGV2ZWwK
