From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 1/2] ext4: Fix bugs in mballoc's stream allocation mode
Date: Sat,  8 Aug 2009 18:52:44 -0400
Message-ID: <1249771965-26611-1-git-send-email-tytso@mit.edu>
References: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Cc: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59877 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZHHWwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Aug 2009 18:52:47 -0400
In-Reply-To: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The logic around sbi->s_mb_last_group and sbi->s_mb_last_start was all
screwed up.  These fields were getting unconditionally allt he time,
set even when stream allocation had not taken place, and if they were
being used when the file was smaller than s_mb_stream_request, which
is when the allocation should _not_ be doing stream allocation.

Fix this by determining whether or not we stream allocation should
take place once, in ext4_mb_group_or_file(), and setting a flag which
gets used in ext4_mb_regular_allocator() and ext4_mb_use_best_found().
This simplifies the code and assures that we are consistently using
(or not using) the stream allocation logic.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/mballoc.c |   23 ++++++++++-------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9714db3..1ca6995 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -88,6 +88,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_HINT_TRY_GOAL		512
 /* blocks already pre-reserved by delayed allocation */
 #define EXT4_MB_DELALLOC_RESERVED      1024
+/* We are doing stream allocation */
+#define EXT4_MB_STREAM_ALLOC	       2048
 
 
 struct ext4_allocation_request {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 68cde59..f019a50 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1360,7 +1360,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	ac->alloc_semp =  e4b->alloc_semp;
 	e4b->alloc_semp = NULL;
 	/* store last allocated for subsequent stream allocation */
-	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
+	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
 		spin_lock(&sbi->s_md_lock);
 		sbi->s_mb_last_group = ac->ac_f_ex.fe_group;
 		sbi->s_mb_last_start = ac->ac_f_ex.fe_start;
@@ -1938,7 +1938,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
-	loff_t size, isize;
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
@@ -1974,20 +1973,16 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	}
 
 	bsbits = ac->ac_sb->s_blocksize_bits;
-	/* if stream allocation is enabled, use global goal */
-	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
-	isize = i_size_read(ac->ac_inode) >> bsbits;
-	if (size < isize)
-		size = isize;
 
-	if (size < sbi->s_mb_stream_request &&
-			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
+	/* if stream allocation is enabled, use global goal */
+	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
 		/* TBD: may be hot point */
 		spin_lock(&sbi->s_md_lock);
 		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
 		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
 		spin_unlock(&sbi->s_md_lock);
 	}
+
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
 	/*
@@ -4155,16 +4150,18 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
 		return;
 
+	if (unlikely(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
+		return;
+
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
 	isize = i_size_read(ac->ac_inode) >> bsbits;
 	size = max(size, isize);
 
 	/* don't use group allocation for large files */
-	if (size >= sbi->s_mb_stream_request)
-		return;
