From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/14] fs: make the filemap_page_mkwrite prototype consistent
Date: Wed, 16 May 2018 07:43:36 +0200
Message-ID: <20180516054348.15950-3-hch@lst.de>
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

IUNPTkZJR19NTVUgdmVyc2lvbiBkaWRuJ3QgYWdyZWUgd2l0aCB0aGUgcmVzdCBvZiB0aGUga2Vy
bmVsLi4KClNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgotLS0K
IG1tL2ZpbGVtYXAuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRl
eCA1MjUxN2YyOGU2ZjQuLmNmMjFjZWQ5OGVmZiAxMDA2NDQKLS0tIGEvbW0vZmlsZW1hcC5jCisr
KyBiL21tL2ZpbGVtYXAuYwpAQCAtMjc0OCw3ICsyNzQ4LDcgQEAgaW50IGdlbmVyaWNfZmlsZV9y
ZWFkb25seV9tbWFwKHN0cnVjdCBmaWxlICpmaWxlLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZt
YSkKIAlyZXR1cm4gZ2VuZXJpY19maWxlX21tYXAoZmlsZSwgdm1hKTsKIH0KICNlbHNlCi1pbnQg
ZmlsZW1hcF9wYWdlX21rd3JpdGUoc3RydWN0IHZtX2ZhdWx0ICp2bWYpCit2bV9mYXVsdF90IGZp
bGVtYXBfcGFnZV9ta3dyaXRlKHN0cnVjdCB2bV9mYXVsdCAqdm1mKQogewogCXJldHVybiAtRU5P
U1lTOwogfQotLSAKMi4xNy4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9k
cmktZGV2ZWwK
