From: mhocko@kernel.org
Subject: [RFC 3/8] mm: page_alloc: do not lock up GFP_NOFS allocations upon OOM
Date: Wed,  5 Aug 2015 11:51:19 +0200
Message-ID: <1438768284-30927-4-git-send-email-mhocko@kernel.org>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Cc: <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	Michal Hocko <mhocko@suse.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

GFP_NOFS allocations are not allowed to invoke the OOM killer since
their reclaim abilities are severely diminished.  However, without the
OOM killer available there is no hope of progress once the reclaimable
pages have been exhausted.

Don't risk hanging these allocations.  Leave it to the allocation site
to implement the fallback policy for failing allocations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/page_alloc.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee69c338ca2a..024d45d51700 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2715,15 +2715,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 		if (ac->high_zoneidx < ZONE_NORMAL)
 			goto out;
 		/* The OOM killer does not compensate for IO-less reclaim */
-		if (!(gfp_mask & __GFP_FS)) {
-			/*
-			 * XXX: Page reclaim didn't yield anything,
-			 * and the OOM killer can't be invoked, but
-			 * keep looping as per tradition.
-			 */
-			*did_some_progress = 1;
+		if (!(gfp_mask & __GFP_FS))
 			goto out;
-		}
 		if (pm_suspended_storage())
 			goto out;
 		/* The OOM killer may not free memory on a specific node */
-- 
2.5.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
