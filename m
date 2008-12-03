From: <gregkh@suse.de>
Subject: patch ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch added to 2.6.27-stable tree
Date: Wed, 03 Dec 2008 10:56:02 -0800
Message-ID: <20081203185929.C024D4904D@coco.kroah.org>
References: <1226851540-8032-2-git-send-email-tytso@mit.edu>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: frederic.bohe@bull.net, gregkh@suse.de, linux-ext4@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbYLCS7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Dec 2008 13:59:30 -0500
In-Reply-To: <1226851540-8032-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext4: Update flex_bg free blocks and free inodes counters when resizing.

to the 2.6.27-stable tree.  Its filename is

    ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From tytso@mit.edu  Wed Dec  3 09:54:56 2008
From: Frederic Bohe <frederic.bohe@bull.net>
Date: Sun, 16 Nov 2008 11:05:21 -0500
Subject: ext4: Update flex_bg free blocks and free inodes counters when resizing.
To: stable@kernel.org
Cc: Frederic Bohe <frederic.bohe@bull.net>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1226851540-8032-2-git-send-email-tytso@mit.edu>


From: Frederic Bohe <frederic.bohe@bull.net>

(cherry picked from commit c62a11fd9555007b1caab83b5bcbb443a43e32bb)

This fixes a bug which prevented the newly created inodes after a
resize from being used on filesystems with flex_bg.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/resize.c |    9 +++++++++
 fs/ext4/super.c  |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -929,6 +929,15 @@ int ext4_group_add(struct super_block *s
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		ext4_group_t flex_group;
+		flex_group = ext4_flex_group(sbi, input->group);
+		sbi->s_flex_groups[flex_group].free_blocks +=
+			input->free_blocks_count;
+		sbi->s_flex_groups[flex_group].free_inodes +=
+			EXT4_INODES_PER_GROUP(sb);
+	}
+
 	ext4_journal_dirty_metadata(handle, sbi->s_sbh);
 	sb->s_dirt = 1;
 
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1504,8 +1504,11 @@ static int ext4_fill_flex_info(struct su
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
-	flex_group_count = (sbi->s_groups_count + groups_per_flex - 1) /
-		groups_per_flex;
+	/* We allocate both existing and potentially added groups */
+	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
+			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
+			   groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {


Patches currently in stable-queue which might be from frederic.bohe@bull.net are

queue-2.6.27/ext4-update-flex_bg-free-blocks-and-free-inodes-counters-when-resizing.patch
queue-2.6.27/ext4-fix-initialization-of-uninit-bitmap-blocks.patch
queue-2.6.27/ext4-add-checksum-calculation-when-clearing-uninit-flag-in-ext4_new_inode.patch
