From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: Sun, 7 Oct 2012 22:41:26 -0400
Message-ID: <20121008024126.GC468@thunk.org>
References: <20121007225403.GA468@thunk.org>
 <20121008012534.31073.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tm@tao.ma
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54349 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2JHCla (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Oct 2012 22:41:30 -0400
Content-Disposition: inline
In-Reply-To: <20121008012534.31073.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I found the problem.  It turns out ext4_handle_dirty_super() was
completely FUBAR'ed and was calculating the checksum on the wrong data
(for all but 1k block file systems, sigh).

We just didn't notice because the checksum would be correctly set when
the file system was unmounted cleanly.  (Sigh).

The following patch should fix things.  Thanks for testing out the
metadata checksum on the root file system, and reporting this
problem!!!

						- Ted

>From bdd7ed290bf12c2e9132fbe97208a1af79c7a29d Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 7 Oct 2012 22:18:56 -0400
Subject: [PATCH] ext4: fix metadata checksum calculation for the superblock

The function ext4_handle_dirty_super() was calculating the superblock
on the wrong block data.  As a result, when the superblock is modified
while it is mounted (most commonly, when inodes are added or removed
from the orphan list), the superblock checksum would be wrong.  We
didn't notice because the superblock *was* being correctly calculated
in ext4_commit_super(), and this would get called when the file system
was unmounted.  So the problem only became obvious if the system
crashed while the file system was mounted.

Fix this by removing the poorly designed function signature for
ext4_superblock_Csum_set(); if it only took a single argument, the
pointer to a struct superblock, the ambiguity which caused this
mistake would have been impossible.

Reported-by: George Spelvin <linux@horizon.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/ext4.h      | 3 +--
 fs/ext4/ext4_jbd2.c | 8 ++------
 fs/ext4/super.c     | 7 ++++---
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3ab2539..78971cf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2063,8 +2063,7 @@ extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count);
 extern int ext4_calculate_overhead(struct super_block *sb);
 extern int ext4_superblock_csum_verify(struct super_block *sb,
 				       struct ext4_super_block *es);
-extern void ext4_superblock_csum_set(struct super_block *sb,
-				     struct ext4_super_block *es);
+extern void ext4_superblock_csum_set(struct super_block *sb);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index bfa65b4..b4323ba 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -143,17 +143,13 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
 	int err = 0;
 
+	ext4_superblock_csum_set(sb);
 	if (ext4_handle_valid(handle)) {
-		ext4_superblock_csum_set(sb,
-				(struct ext4_super_block *)bh->b_data);
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
-	} else {
-		ext4_superblock_csum_set(sb,
-				(struct ext4_super_block *)bh->b_data);
+	} else
 		mark_buffer_dirty(bh);
-	}
 	return err;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 982f6fc..5ededf1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -143,9 +143,10 @@ int ext4_superblock_csum_verify(struct super_block *sb,
 	return es->s_checksum == ext4_superblock_csum(sb, es);
 }
 
-void ext4_superblock_csum_set(struct super_block *sb,
-			      struct ext4_super_block *es)
+void ext4_superblock_csum_set(struct super_block *sb)
 {
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return;
@@ -4387,7 +4388,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		cpu_to_le32(percpu_counter_sum_positive(
 				&EXT4_SB(sb)->s_freeinodes_counter));
 	BUFFER_TRACE(sbh, "marking dirty");
-	ext4_superblock_csum_set(sb, es);
+	ext4_superblock_csum_set(sb);
 	mark_buffer_dirty(sbh);
 	if (sync) {
 		error = sync_dirty_buffer(sbh);
-- 
1.7.12.rc0.22.gcdd159b

