From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add PF_MEMALLOC_NOFS
Date: Wed, 27 Apr 2016 09:07:02 +1000
Message-ID: <20160426230702.GG26977@dastard>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
 <1461671772-1269-2-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>,
	Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org,
	cluster-devel@redhat.com, linux-nfs@vger.kernel.org,
	logfs@logfs.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
	Michal Hocko <mhocko@suse.com>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 26, 2016 at 01:56:11PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> GFP_NOFS context is used for the following 4 reasons currently
> 	- to prevent from deadlocks when the lock held by the allocation
> 	  context would be needed during the memory reclaim
> 	- to prevent from stack overflows during the reclaim because
> 	  the allocation is performed from a deep context already
> 	- to prevent lockups when the allocation context depends on
> 	  other reclaimers to make a forward progress indirectly
> 	- just in case because this would be safe from the fs POV

- silencing lockdep false positives

> Introduce PF_MEMALLOC_NOFS task specific flag and memalloc_nofs_{save,restore}
> API to control the scope. This is basically copying
> memalloc_noio_{save,restore} API we have for other restricted allocation
> context GFP_NOIO.
> 
> Xfs has already had a similar functionality as PF_FSTRANS so let's just
> give it a more generic name and make it usable for others as well and
> move the GFP_NOFS context tracking to the page allocator. Xfs has its
> own accessor functions but let's keep them for now to reduce this patch
> as minimum.

Can you split this into two patches? The first simply does this:

#define PF_MEMALLOC_NOFS PF_FSTRANS

and changes only the XFS code to use PF_MEMALLOC_NOFS.

The second patch can then do the rest of the mm API changes that we
don't actually care about in XFS at all.  That way I can carry all
the XFS changes in the XFS tree and not have to worry about when
this stuff gets merged or conflicts with the rest of the work that
is being done to the mm/ code and whatever tree that eventually
lands in...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
