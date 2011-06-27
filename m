From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 3/3] ext3: Explicitly specify fsync dependency on journaling thread
Date: Mon, 27 Jun 2011 16:17:44 -0400
Message-ID: <1309205864-13124-4-git-send-email-vgoyal@redhat.com>
References: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Cc: vgoyal@redhat.com, khlebnikov@openvz.org, jmoyer@redhat.com
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153Ab1F0URt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 16:17:49 -0400
In-Reply-To: <1309205864-13124-1-git-send-email-vgoyal@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Set/reset fsync dependency of fsync on journalling thread. This allows
CFQ to dispatch IO from journalling thread in fsync's time slice.
Otherwise, lots of cfq queue idling takes place if fsync is running
in a separate cgroup and journalling thread is running in root group.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/ext3/fsync.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 09b13bb..1e8de9c 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -82,7 +82,10 @@ int ext3_sync_file(struct file *file, int datasync)
 	    !journal_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = 1;
 	log_start_commit(journal, commit_tid);
+	blk_set_depends_on_task(journal->j_dev->bd_disk->queue,
+				journal->j_task);
 	ret = log_wait_commit(journal, commit_tid);
+	blk_reset_depends_on_task(journal->j_dev->bd_disk->queue);
 
 	/*
 	 * In case we didn't commit a transaction, we have to flush
-- 
1.7.4.4

