From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1.2/2] mm: introduce memalloc_nofs_{save,restore} API
Date: Wed, 27 Apr 2016 23:14:14 +0200
Message-ID: <20160427211414.GA24919@dhcp22.suse.cz>
References: <1461671772-1269-2-git-send-email-mhocko@kernel.org>
 <1461758075-21815-1-git-send-email-mhocko@kernel.org>
 <1461758075-21815-2-git-send-email-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>,
	Jan Kara <jack@suse.cz>, ceph-devel@vger.kernel.org,
	cluster-devel@redhat.com, linux-nfs@vger.kernel.org,
	logfs@logfs.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-mtd@lists.infradead.org,
	reiserfs-devel@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461758075-21815-2-git-send-email-mhocko@kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

OK, so the lockdep splats I was seeing [1] were much easier to fix than
I originally thought. So the following should be folded into the
original patch. I will send the full patch later on.

[1] http://lkml.kernel.org/r/20160427200927.GC22544@dhcp22.suse.cz
---
>From 1968c0a8ace4090a9deca8f4c1a206ee546e595a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 27 Apr 2016 22:32:57 +0200
Subject: [PATCH] fold me "mm: introduce memalloc_nofs_{save,restore} API"

Lockdep infrastructure is hooked into early hot paths of the allocator
so __lockdep_trace_alloc has to check for PF_MEMALLOC_NOFS directly and
do not rely on current_gfp_context

Signed-off-by: Michal Hocko <mhocko@suse.com>

---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 716547fdb873..f60124d0871c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2750,7 +2750,7 @@ static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
 		return;
 
 	/* We're only interested __GFP_FS allocations for now */
-	if (!(gfp_mask & __GFP_FS))
+	if (!(gfp_mask & __GFP_FS) || (curr->flags & PF_MEMALLOC_NOFS))
 		return;
 
 	/*
-- 
2.8.0.rc3

-- 
Michal Hocko
SUSE Labs
