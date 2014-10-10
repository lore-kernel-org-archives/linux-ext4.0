From: Jan Kara <jack@suse.cz>
Subject: [PATCH] block: free q->flush_rq in blk_init_allocated_queue error paths
Date: Fri, 10 Oct 2014 16:23:07 +0200
Message-ID: <1412951028-4085-3-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Dave Jones <davej@redhat.com>,
	Dave Jones <davej@fedoraproject.org>,
	Jens Axboe <axboe@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dave Jones <davej@redhat.com>

Commit 7982e90c3a57 ("block: fix q->flush_rq NULL pointer crash on
dm-mpath flush") moved an allocation to blk_init_allocated_queue(), but
neglected to free that allocation on the error paths that follow.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 block/blk-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4cd5ffc18442..bfe16d5af9f9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -713,7 +713,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
-		return NULL;
+		goto fail;
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
@@ -737,12 +737,16 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	/* init elevator */
 	if (elevator_init(q, NULL)) {
 		mutex_unlock(&q->sysfs_lock);
-		return NULL;
+		goto fail;
 	}
 
 	mutex_unlock(&q->sysfs_lock);
 
 	return q;
+
+fail:
+	kfree(q->flush_rq);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
 
-- 
1.8.1.4

