From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH] mm: introduce kv[mz]alloc helpers
Date: Fri, 9 Dec 2016 07:18:00 +0100
Message-ID: <20161209061759.GA12012@dhcp22.suse.cz>
References: <20161208103300.23217-1-mhocko@kernel.org>
 <20161209014417.GN4326@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Anatoly Stepanov <astepanov@cloudlinux.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, kvm@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20161209014417.GN4326@dastard>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 09-12-16 12:44:17, Dave Chinner wrote:
> On Thu, Dec 08, 2016 at 11:33:00AM +0100, Michal Hocko wrote:
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > Using kmalloc with the vmalloc fallback for larger allocations is a
> > common pattern in the kernel code. Yet we do not have any common helper
> > for that and so users have invented their own helpers. Some of them are
> > really creative when doing so. Let's just add kv[mz]alloc and make sure
> > it is implemented properly. This implementation makes sure to not make
> > a large memory pressure for > PAGE_SZE requests (__GFP_NORETRY) and also
> > to not warn about allocation failures. This also rules out the OOM
> > killer as the vmalloc is a more approapriate fallback than a disruptive
> > user visible action.
> > 
> > This patch also changes some existing users and removes helpers which
> > are specific for them. In some cases this is not possible (e.g.
> > ext4_kvmalloc, libcfs_kvzalloc, __aa_kvmalloc) because those seems to be
> > broken and require GFP_NO{FS,IO} context which is not vmalloc compatible
> > in general (note that the page table allocation is GFP_KERNEL). Those
> > need to be fixed separately.
> 
> See fs/xfs/kmem.c::kmem_zalloc_large(), which is XFS's version of
> kvmalloc() that is GFP_NOFS/GFP_NOIO safe. Any generic API for this
> functionality will have to play these memalloc_noio_save/
> memalloc_noio_restore games to ensure they are GFP_NOFS safe....

Well, I didn't want to play this games in the generic kvmalloc, at least
not now, because all the converted users didn't really need it so far
and I believe that the existing users need a) inspection to check
whether NO{FS,IO} context is really needed and b) I still believe that
the scope nofs api should be used longterm rather than an explicit
GFP_NOFS. I am already working on ext[34] code.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
