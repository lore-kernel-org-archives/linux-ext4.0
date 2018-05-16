From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/14] mm: turn on vm_fault_t type checking
Date: Wed, 16 May 2018 19:34:45 +0200
Message-ID: <20180516173445.GA6088@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
 <20180516054348.15950-15-hch@lst.de> <20180516150829.GA4904@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-btrfs@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, ocfs2-devel@oss.oracle.com,
 Souptick Joarder <jrdr.linux@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 devel@lists.orangefs.org, lustre-devel@lists.lustre.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180516150829.GA4904@magnolia>
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

T24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDg6MDg6MjlBTSAtMDcwMCwgRGFycmljayBKLiBXb25n
IHdyb3RlOgo+IFVoLCB3ZSdyZSBjaGFuZ2luZyBmdW5jdGlvbiBzaWduYXR1cmVzIC9hbmQvIHJl
ZGVmaW5pbmluZyB2bV9mYXVsdF90Pwo+IEFsbCBpbiB0aGUgc2FtZSA5MEsgcGF0Y2g/Cj4gCj4g
SSAvd2FzLyBleHBlY3RpbmcgYSBzZXJpZXMgb2YgImNvbnZlcnQgWFhYWFggYW5kIGFsbCBjYWxs
ZXJzL3VzZXJzIgo+IHBhdGNoZXMgZm9sbG93ZWQgYnkgYSB0cml2aWFsIG9uZSB0byBzd2l0Y2gg
dGhlIGRlZmluaXRpb24sIG5vdCBhIGdpYW50Cj4gcGlsZSBvZiBjaGFuZ2UuICBGV0lXIEkgZG9u
J3QgbWluZCBzbyBtdWNoIGlmIHlvdSBtYWtlIGEgcGF0Y2gKPiBjb250YWluaW5nIGEgY2hhbmdl
IGZvciBzb21lIHN1cGVyLWNvbW1vbiBwcmltaXRpdmUgYW5kIGEgaG9qaWxsaW9uCj4gbGl0dGxl
IGRpZmYgaHVua3MgdHJlZS13aWRlLCBidXQgb25seSBvbmUgbG9naWNhbCBjaGFuZ2UgYXQgYSB0
aW1lIGZvciBhCj4gYmlnIHBhdGNoLCBwbGVhc2UuLi4KPiAKPiBJIHF1aXRlIHByZWZlciBzZWVp
bmcgdGhlIHdob2xlIHNlcmllcyBmcm9tIHN0YXJ0IHRvIGZpbmlzaCBhbGwgcGFja2FnZWQKPiB1
cCBpbiBvbmUgc2VyaWVzLCBidXQgd293IHRoaXMgd2FzIG92ZXJ3aGVsbWluZy4gOi8KCkFub3Ro
ZXIgdm90ZSB0byBzcGxpdCB0aGUgY2hhbmdlIG9mIHRoZSB0eXBlZGVmLCBvayBJIGdldCB0aGUg
bWVzc2FnZS4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
