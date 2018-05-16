From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/14] mm: turn on vm_fault_t type checking
Date: Wed, 16 May 2018 15:03:44 +0200
Message-ID: <20180516130344.GC32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
 <20180516054348.15950-15-hch@lst.de>
 <20180516112813.GC20670@bombadil.infradead.org>
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
In-Reply-To: <20180516112813.GC20670@bombadil.infradead.org>
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

T24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDQ6Mjg6MTNBTSAtMDcwMCwgTWF0dGhldyBXaWxjb3gg
d3JvdGU6Cj4gT24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMDc6NDM6NDhBTSArMDIwMCwgQ2hyaXN0
b3BoIEhlbGx3aWcgd3JvdGU6Cj4gPiBTd2l0Y2ggdm1fZmF1bHRfdCB0byBwb2ludCB0byBhbiB1
bnNpZ25lZCBpbnQgd2l0aCBfX2LRlnR3aXNlIGFubm90YXRpb25zLgo+ID4gVGhpcyBib3RoIGNh
dGNoZXMgYW55IG9sZCAtPmZhdWx0IG9yIC0+cGFnZV9ta3dyaXRlIGluc3RhbmNlIHdpdGggcGxh
aW4KPiA+IGNvbXBpbGVyIHR5cGUgY2hlY2tpbmcsIGFzIHdlbGwgYXMgZmluZGluZyBtb3JlIGlu
dHJpY2F0ZSBwcm9ibGVtcyB3aXRoCj4gPiBzcGFyc2UuCj4gCj4gQ29tZSBvbiwgQ2hyaXN0b3Bo
OyB5b3Uga25vdyBiZXR0ZXIgdGhhbiB0aGlzLiAgVGhpcyBwYXRjaCBpcyBjb21wbGV0ZWx5Cj4g
dW5yZXZpZXdhYmxlLiAgU3BsaXQgaXQgaW50byBvbmUgcGF0Y2ggcGVyIG1haW50YWluZXIgdHJl
ZSwgYW5kIGluIGFueQo+IGV2ZW50LCB0aGUgcGF0Y2ggdG8gY29udmVydCB2bV9mYXVsdF90IHRv
IGFuIHVuc2lnbmVkIGludCBzaG91bGQgYmUKPiBzZXBhcmF0ZWQgZnJvbSBhbGwgdGhlIHRyaXZp
YWwgY29udmVyc2lvbnMuCgpUaGUgd2hvbGUgcG9pbnQgaXMgdGhhdCB0aW55IHNwbGl0IHBhdGNo
ZXMgZm9yIG1lY2huaWNhbCB0cmFuc2xhdGlvbnMKYXJlIHRvdGFsbHkgcG9pbnRsZXNzLiAgU3dp
dGNoaW5nIHRoZSB0eXBlZGVmIG1pZ2h0IGJlIHdvcnRoIHNwbGl0dGluZwppZiBwZW9wbGUgcmVh
bGx5IGluc2lzdC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
Cg==
