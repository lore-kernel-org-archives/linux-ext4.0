From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/14] mm: remove the unused device_private_entry_fault export
Date: Wed, 16 May 2018 07:43:38 +0200
Message-ID: <20180516054348.15950-5-hch@lst.de>
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

U2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Ci0tLQoga2VybmVs
L21lbXJlbWFwLmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEva2VybmVsL21lbXJlbWFwLmMgYi9rZXJuZWwvbWVtcmVtYXAuYwppbmRleCBkYjRlMWEz
NzNlNWYuLjU5ZWUzYjYwNGIzOSAxMDA2NDQKLS0tIGEva2VybmVsL21lbXJlbWFwLmMKKysrIGIv
a2VybmVsL21lbXJlbWFwLmMKQEAgLTY1LDcgKzY1LDYgQEAgaW50IGRldmljZV9wcml2YXRlX2Vu
dHJ5X2ZhdWx0KHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLAogCSAqLwogCXJldHVybiBwYWdl
LT5wZ21hcC0+cGFnZV9mYXVsdCh2bWEsIGFkZHIsIHBhZ2UsIGZsYWdzLCBwbWRwKTsKIH0KLUVY
UE9SVF9TWU1CT0woZGV2aWNlX3ByaXZhdGVfZW50cnlfZmF1bHQpOwogI2VuZGlmIC8qIENPTkZJ
R19ERVZJQ0VfUFJJVkFURSAqLwogCiBzdGF0aWMgdm9pZCBwZ21hcF9yYWRpeF9yZWxlYXNlKHN0
cnVjdCByZXNvdXJjZSAqcmVzLCB1bnNpZ25lZCBsb25nIGVuZF9wZ29mZikKLS0gCjIuMTcuMAoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==
