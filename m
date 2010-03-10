From: Jan Kara <jack@suse.cz>
Subject: Re: [Bug 15420] EXT4_USE_FOR_EXT23 causes wrong free space
	calculation on ext2 and ext3
Date: Wed, 10 Mar 2010 12:29:16 +0100
Message-ID: <20100310112916.GB22934@atrey.karlin.mff.cuni.cz>
References: <bug-15420-13602@http.bugzilla.kernel.org/> <201003100312.o2A3CmXg009132@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36392 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754271Ab0CJL3S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Mar 2010 06:29:18 -0500
Content-Disposition: inline
In-Reply-To: <201003100312.o2A3CmXg009132@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> http://bugzilla.kernel.org/show_bug.cgi?id=15420
> 
> 
> Theodore Tso <tytso@mit.edu> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |tytso@mit.edu
> 
> 
> 
> 
> --- Comment #5 from Theodore Tso <tytso@mit.edu>  2010-03-10 03:12:30 ---
> This sounds like the block reservation code for delayed allocation is
> over-aggressive about estimating how many blocks are need for the indirect
> blocks in the case of indirect-mapped inodes (which would be what you get when
> mounting an ext2 filesystem using the ext4 file system driver).
> 
> This should be an aesthetic issue only, but it would be nice to have this be
> fixed.
  Since bugzilla seems to be down now, I'll reply by email:
Won't it make sence to use 'nodelalloc' by default when ext4 driver is used
for ext2 or ext3 filesystem? Because delayed allocation has some implications
people need not expect - like the overestimation of needed blocks, or changed
semantics of ordered data mode etc...
  So something like the patch below?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
---
>From c5fa50757c0b81f661532b6f833946bd9294e439 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 10 Mar 2010 12:23:03 +0100
Subject: [PATCH] ext4: Don't use delayed allocation by default when used instead of ext[23]

When ext4 driver is used to mount a filesystem instead of ext2 or ext3 driver,
do not enable delayed allocation by default since it has some unobvious
consequences (different semantics of data=ordered mode, overestimation of
needed metadata blocks for allocation).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ce84a6e..7fc9ab3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -68,7 +68,16 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int ext4_unfreeze(struct super_block *sb);
 static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
+static int ext4_get_sb(struct file_system_type *fs_type, int flags,
+		       const char *dev_name, void *data, struct vfsmount *mnt);
 
+static struct file_system_type ext4_fs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "ext4",
+	.get_sb		= ext4_get_sb,
+	.kill_sb	= kill_block_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
@@ -2539,7 +2548,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * enable delayed allocation by default
 	 * Use -o nodelalloc to turn it off
 	 */
-	set_opt(sbi->s_mount_opt, DELALLOC);
+	if (sb->s_bdev->bd_holder == &ext4_fs_type)
+		set_opt(sbi->s_mount_opt, DELALLOC);
 
 	if (!parse_options((char *) data, sb, &journal_devnum,
 			   &journal_ioprio, NULL, 0))
@@ -4122,14 +4132,6 @@ static inline void register_as_ext3(void) { }
 static inline void unregister_as_ext3(void) { }
 #endif
 
-static struct file_system_type ext4_fs_type = {
-	.owner		= THIS_MODULE,
-	.name		= "ext4",
-	.get_sb		= ext4_get_sb,
-	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV,
-};
