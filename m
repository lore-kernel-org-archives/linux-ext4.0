From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fallback to vmalloc if kmalloc can't allocate
	s_flex_groups array
Date: Fri, 24 Apr 2009 23:57:39 -0400
Message-ID: <20090425035739.GG13608@mit.edu>
References: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com> <1240628459-25582-1-git-send-email-tytso@mit.edu> <49F28344.4010707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Rubin <mrubin@google.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58264 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZDYD5r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 23:57:47 -0400
Content-Disposition: inline
In-Reply-To: <49F28344.4010707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 24, 2009 at 10:28:04PM -0500, Eric Sandeen wrote:
> 
> er, won't you need the same vfree/kfree treatment in ext4_put_super? :)
> 

Yeah, good catch.  Time for me to go to bed...  Here's the fixed
patch.

						- Ted

>From 1fbe30e0fed504fd021c9d35998b4815f34be73e Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 24 Apr 2009 23:57:15 -0400
Subject: [PATCH] ext4: Fallback to vmalloc if kmalloc can't allocate s_flex_groups array

For very large filesystems, the s_flex_groups array can get quite big.
For example, a 16TB filesystem will have 8192 flex groups by default,
so the array is 96k, which is *very* marginal for kmalloc().  On the
other hand, a 160GB filesystem will have 80 flex groups, so the array
will be 960 bytes.  So we try to allocate the array first using
kmalloc(), and if that fails, we'll try to use vmalloc() instead.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..f19d8b8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -586,7 +586,10 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	kfree(sbi->s_flex_groups);
+	if (is_vmalloc_addr(sbi->s_flex_groups))
+		vfree(sbi->s_flex_groups);
+	else
+		kfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1620,6 +1623,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
+	size_t size;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1634,8 +1638,13 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
-	sbi->s_flex_groups = kzalloc(flex_group_count *
-				     sizeof(struct flex_groups), GFP_KERNEL);
+	size = flex_group_count * sizeof(struct flex_groups);
+	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
+	if (sbi->s_flex_groups == NULL) {
+		sbi->s_flex_groups = vmalloc(size);
+		if (sbi->s_flex_groups)
+			memset(sbi->s_flex_groups, 0, size);
+	}
 	if (sbi->s_flex_groups == NULL) {
 		printk(KERN_ERR "EXT4-fs: not enough memory for "
 				"%u flex groups\n", flex_group_count);
@@ -2842,6 +2851,12 @@ failed_mount4:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
+	if (sbi->s_flex_groups) {
+		if (is_vmalloc_addr(sbi->s_flex_groups))
+			vfree(sbi->s_flex_groups);
+		else
+			kfree(sbi->s_flex_groups);
+	}
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
1.5.6.3

