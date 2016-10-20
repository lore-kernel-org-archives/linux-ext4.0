From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix mmp use after free during unmount
Date: Thu, 20 Oct 2016 13:19:39 -0500
Message-ID: <0b8909ed-ae65-1a89-263c-12aff513377a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: shuwang@redhat.com
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38570 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752101AbcJTSTl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Oct 2016 14:19:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAF1719D22F
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2016 18:19:40 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_put_super, we call brelse on the buffer head containing
the ext4 superblock, but then try to use it when we stop the
mmp thread, because when the thread shuts down it does:

write_mmp_block
  ext4_mmp_csum_set
    ext4_has_metadata_csum
      WARN_ON_ONCE(ext4_has_feature_metadata_csum(sb)...)

which reaches into sb->s_fs_info->s_es->s_feature_ro_compat,
which lives in the superblock buffer s_sbh which we just released.

Fix this by moving the brelse down to a point where we are no
longer using it.

Reported-by: Wang Shu <shuwang@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note: found by inspection after a bug report via KASAN,
compile-tested only.

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6db81fb..f273212 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -862,7 +862,6 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
 	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
-	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(sbi->s_qf_names[i]);
@@ -894,6 +893,9 @@ static void ext4_put_super(struct super_block *sb)
 	}
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
+
+	/* Don't let this go until everything is done with the ext4 super */
+	brelse(sbi->s_sbh);
 	sb->s_fs_info = NULL;
 	/*
 	 * Now that we are completely done shutting down the


