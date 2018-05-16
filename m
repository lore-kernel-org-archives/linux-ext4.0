From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/14] vgem: separate errno from VM_FAULT_* values
Date: Wed, 16 May 2018 15:01:59 +0200
Message-ID: <20180516130159.GA32454@lst.de>
References: <20180516054348.15950-1-hch@lst.de>
 <20180516054348.15950-11-hch@lst.de>
 <20180516095303.GH3438@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: Christoph Hellwig <hch@lst.de>, Souptick Joarder <jrdr.linux@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 devel@lists.orangefs.org, ceph-devel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
 dri-devel@lists.freedesktop.org, lustre-devel@lists.lustre.org,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180516095303.GH3438@phenom.ffwll.local>
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

T24gV2VkLCBNYXkgMTYsIDIwMTggYXQgMTE6NTM6MDNBTSArMDIwMCwgRGFuaWVsIFZldHRlciB3
cm90ZToKPiBSZXZpZXdlZC1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBmZndsbC5j
aD4KPiAKPiBXYW50IG1lIHRvIG1lcmdlIHRoaXMgdGhyb3VnaCBkcm0tbWlzYyBvciBwbGFuIHRv
IHBpY2sgaXQgdXAgeW91cnNlbGY/CgpGb3Igbm93IEkganVzdCB3YW50IGEgaG9uZXN0IGRpc2N1
c3Npb24gaWYgcGVvcGxlIHJlYWxseSBhY3R1YWxseQp3YW50IHRoZSB2bV9mYXVsdF90IGNoYW5n
ZSB3aXRoIHRoZSB3aG9sZSBwaWN0dXJlIGluIHBsYWNlLgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZl
bEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
