From: Christoph Hellwig <hch@lst.de>
Subject: Re: vm_fault_t conversion, for real
Date: Wed, 16 May 2018 15:03:09 +0200
Message-ID: <20180516130309.GB32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
 <20180516112347.GB20670@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 ocfs2-devel@oss.oracle.com, Souptick Joarder <jrdr.linux@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, devel@lists.orangefs.org,
 lustre-devel@lists.lustre.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180516112347.GB20670@bombadil.infradead.org>
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

T24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDQ6MjM6NDdBTSAtMDcwMCwgTWF0dGhldyBXaWxjb3gg
d3JvdGU6Cj4gT24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDc6NDM6MzRBTSArMDIwMCwgQ2hyaXN0
b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiB0aGlzIHNlcmllcyB0cmllcyB0byBhY3R1YWxseSB0dXJu
IHZtX2ZhdWx0X3QgaW50byBhIHR5cGUgdGhhdCBjYW4gYmUKPiA+IHR5cGVjaGVja2VkIGFuZCBj
aGVja3MgdGhlIGZhbGxvdXQgaW5zdGVhZCBvZiBzcHJpbmtsaW5nIHJhbmRvbQo+ID4gYW5ub3Rh
dGlvbnMgd2l0aG91dCBjb250ZXh0Lgo+IAo+IFllcywgd2h5IHNob3VsZCB3ZSBoYXZlIHNtYWxs
IHRhc2tzIHRoYXQgbmV3Y29tZXJzIGNhbiBkbyB3aGVuIHRoZSBtaWdodHkKPiBDaHJpc3RvcGgg
SGVsbHdpZyBjYW4gc3dvb3AgaW4gYW5kIHRha2Ugb3ZlciBmcm9tIHRoZW0/ICBTZXJpb3VzbHks
Cj4gY2FuJ3QgeW91ciB0YWxlbnRzIGZpbmQgYSBiZXR0ZXIgdXNlIHRoYW4gdGhpcz8KCkkndmUg
c3BlbnQgbGVzcyB0aW1lIG9uIHRoaXMgdGhhbiB0cnlpbmcgdG8gYXJndWUgdG8geW91IGFuZCBT
b3VwdGljawp0aGF0IHRoZXNlIGNoYW5nZXMgYXJlIG9ubHkgdG8gZ2V0IGlnbm9yZWQgYW5kIHll
bGxlZCBhdCBhcyBhbgoiYXNzaG9sZSBtYWludGFpbmVyIi4gIFNvIHllcywgSSBjb3VsZCBoYXZl
IGRvbmUgbW9yZSBwcm9kdWN0aXZlIHRoaW5ncwppZiB5b3UgaGFkbid0IGZvcmNlZCB0aGlzIGVz
Y2FsYXRpb24uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CmRyaS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
