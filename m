From: akpm@linux-foundation.org
Subject: + revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch added to -mm tree
Date: Tue, 03 Feb 2009 13:04:46 -0800
Message-ID: <200902032104.n13L4leU024287@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbZBCVFn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Feb 2009 16:05:43 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: revert "ext3: wait on all pending commits in ext3_sync_fs"
has been added to the -mm tree.  Its filename is
     revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: revert "ext3: wait on all pending commits in ext3_sync_fs"
From: Jan Kara <jack@suse.cz>

This reverts commit c87591b719737b4e91eb1a9fa8fd55a4ff1886d6.

Since journal_start_commit() is now fixed to return 1 when we started a
transaction commit, there's some transaction waiting to be committed or
there's a transaction already committing, we don't need to call
ext3_force_commit() in ext3_sync_fs().  Furthermore ext3_force_commit()
can unnecessarily create sync transaction which is expensive so it's
worthwhile to remove it when we can.

Cc: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/ext3/super.c~revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs fs/ext3/super.c
--- a/fs/ext3/super.c~revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs
+++ a/fs/ext3/super.c
@@ -2426,12 +2426,13 @@ static void ext3_write_super (struct sup
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
-	sb->s_dirt = 0;
-	if (wait)
-		ext3_force_commit(sb);
-	else
-		journal_start_commit(EXT3_SB(sb)->s_journal, NULL);
+	tid_t target;
 
+	sb->s_dirt = 0;
+	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
+		if (wait)
+			log_wait_commit(EXT3_SB(sb)->s_journal, target);
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
jbd-fix-return-value-of-journal_start_commit.patch
revert-ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch
fs-adfs-return-f_fsid-for-statfs2.patch

