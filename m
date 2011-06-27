From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/3] ext4: Explicitly specify fsync dependency on journaling thread
Date: Mon, 27 Jun 2011 16:17:43 -0400
Message-ID: <1309205864-13124-3-git-send-email-vgoyal@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Cc: vgoyal@redhat.com, khlebnikov@openvz.org, jmoyer@redhat.com
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Set/reset fsync dependency of fsync on journalling thread. This allows
CFQ to dispatch IO from journalling thread in fsync's time slice.
Otherwise, lots of cfq queue idling takes place if fsync is running
in a separate cgroup and journalling thread is running in root group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/ext4/fsync.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index ce66d2f..8b16a90 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -216,7 +216,10 @@ int ext4_sync_file(struct file *file, int datasync)
 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = true;
 	jbd2_log_start_commit(journal, commit_tid);
+	blk_set_depends_on_task(journal->j_dev->bd_disk->queue,
+				journal->j_task);
 	ret = jbd2_log_wait_commit(journal, commit_tid);
+	blk_reset_depends_on_task(journal->j_dev->bd_disk->queue);
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
  out:
-- 
1.7.4.4

