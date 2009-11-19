From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] Unify log messages in ext2
Date: Thu, 19 Nov 2009 15:32:07 +0100
Message-ID: <20091119143207.GA24836@duck.suse.cz>
References: <1258629463-3767-1-git-send-email-bug-track@fisher-privat.net>
 <1258630211-4024-1-git-send-email-bug-track@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58952 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbZKSOcD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2009 09:32:03 -0500
Content-Disposition: inline
In-Reply-To: <1258630211-4024-1-git-send-email-bug-track@fisher-privat.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Thu 19-11-09 12:30:11, Alexey Fisher wrote:
> make messages produced by ext2 more unified. It should be
> easy to parse.
> 
> dmesg before patch:
> [ 4893.684892] reservations ON
> [ 4893.684896] xip option not supported
> [ 4893.684961] EXT2-fs warning: mounting ext3 filesystem as ext2
> [ 4893.684964] EXT2-fs warning: maximal mount count reached, running
> e2fsck is recommended
> [ 4893.684990] EXT II FS: 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> bpg=8192, ipg=1280, mo=80010]
> 
> dmesg after patch:
> [ 4893.684892] EXT2-fs (loop0): reservations ON
> [ 4893.684896] EXT2-fs (loop0): xip option not supported
> [ 4893.684961] EXT2-fs (loop0): warning: mounting ext3 filesystem as
> ext2
> [ 4893.684964] EXT2-fs (loop0): warning: maximal mount count reached,
> running e2fsck is recommended
> [ 4893.684990] EXT2-fs (loop0): 0.5b, 95/08/09, bs=1024, fs=1024, gc=2,
> bpg=8192, ipg=1280, mo=80010]
> 
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> Reviewed-by: Andreas Dilger <adilger@sun.com>
  OK, the patch is almost fine. I have slightly changed a few things -
please have a look below. With them I'm fine with merging the patch.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--

>From 3e8f76349a9a3288a24e3ab9e68c16ea31e13b8a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 19 Nov 2009 15:26:11 +0100
Subject: [PATCH] ext2: Fixup ext2 messages

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c |   19 ++++++++++---------
 fs/ext2/xip.c   |    4 ++--
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 25e8b3c..d3be602 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -92,9 +92,9 @@ void ext2_update_dynamic_rev(struct super_block *sb)
 		return;
 
 	ext2_msg(sb, KERN_WARNING,
-		     "warning: %s: updating to rev %d because of "
+		     "warning: updating to rev %d because of "
 		     "new feature flag, running e2fsck is recommended",
-		     __func__, EXT2_DYNAMIC_REV);
+		     EXT2_DYNAMIC_REV);
 
 	es->s_first_ino = cpu_to_le32(EXT2_GOOD_OLD_FIRST_INO);
 	es->s_inode_size = cpu_to_le16(EXT2_GOOD_OLD_INODE_SIZE);
@@ -419,10 +419,10 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
-static int parse_options (char * options,
-			  struct ext2_sb_info *sbi, struct super_block *sb)
+static int parse_options(char * options, struct super_block *sb)
 {
-	char * p;
+	char *p;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
@@ -833,7 +833,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
-	if (!parse_options((char *) data, sbi, sb))
+	if (!parse_options((char *) data, sb))
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
@@ -1083,7 +1083,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 cantfind_ext2:
 	if (!silent)
 		ext2_msg(sb, KERN_ERR,
-			"error: can't find an ext2 filesystem");
+			"error: can't find an ext2 filesystem on dev %s.",
+			sb->s_id);
 	goto failed_mount;
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
@@ -1185,7 +1186,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	/*
 	 * Allow the "check" option to be passed as a remount option.
 	 */
-	if (!parse_options(data, sbi, sb)) {
+	if (!parse_options(data, sb)) {
 		err = -EINVAL;
 		goto restore_opts;
 	}
@@ -1198,7 +1199,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 
 	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
 		ext2_msg(sb, KERN_WARNING,
-			"wraning: unsupported blocksize for xip");
+			"warning: unsupported blocksize for xip");
 		err = -EINVAL;
 		goto restore_opts;
 	}
diff --git a/fs/ext2/xip.c b/fs/ext2/xip.c
index 8df7502..322a56b 100644
--- a/fs/ext2/xip.c
+++ b/fs/ext2/xip.c
@@ -70,8 +70,8 @@ void ext2_xip_verify_sb(struct super_block *sb)
 	    !sb->s_bdev->bd_disk->fops->direct_access) {
 		sbi->s_mount_opt &= (~EXT2_MOUNT_XIP);
 		ext2_msg(sb, KERN_WARNING,
-			     "warning: %s: ignoring xip option - "
-			     "not supported by bdev", __func__);
+			     "warning: ignoring xip option - "
+			     "not supported by bdev");
 	}
 }
 
-- 
1.6.4.2

