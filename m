From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Mon, 8 Sep 2008 10:39:51 -0400
Message-ID: <20080908143951.GH8161@mit.edu>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907160414.GB26248@charite.de> <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu> <20080907164130.GA3376@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39468 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbYIHOkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Sep 2008 10:40:12 -0400
Content-Disposition: inline
In-Reply-To: <20080907164130.GA3376@x200.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 07, 2008 at 08:41:30PM +0400, Alexey Dobriyan wrote:
> 
> register_disk() uses '!' too, BTW.
> 

Yeah, I guess it's good to be consistent with what's being broadcast
via udev et al.  I still that '!' in pathnames or '/' in device names
is really gross and shows no taste, though.  :-)

Here's what I've checked into the ext4 patch queue for submission to
mainline at the next merge window.  I've added a bit more error
checking in case proc_mkdir() fails and returns NULL.

						- Ted

ext4: fix #11321: create /proc/ext4/*/stats more carefully

From: Alexey Dobriyan <adobriyan@gmail.com>

ext4 creates per-suberblock directory in /proc/ext4/ . Name used as
basis is taken from bdevname, which, surprise, can contain slash.

However, proc while allowing to use proc_create("a/b", parent) form of
PDE creation, assumes that parent/a was already created.

bdevname in question is 'cciss/c0d0p9', directory is not created and all
this stuff goes directly into /proc (which is real bug).

Warning comes when _second_ partition is mounted.

http://bugzilla.kernel.org/show_bug.cgi?id=11321

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2721643..984144d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2785,14 +2785,19 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	mode_t mode = S_IFREG | S_IRUGO | S_IWUSR;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct proc_dir_entry *proc;
-	char devname[64];
+	char devname[64], *p;
 
 	if (proc_root_ext4 == NULL) {
 		sbi->s_mb_proc = NULL;
 		return -EINVAL;
 	}
 	bdevname(sb->s_bdev, devname);
+	while (p = strchr(p, '/'))
+		*p = '!';
+
 	sbi->s_mb_proc = proc_mkdir(devname, proc_root_ext4);
+	if (!sbi->s_mb_proc)
+		goto err_create_dir;
 
 	MB_PROC_HANDLER(EXT4_MB_STATS_NAME, stats);
 	MB_PROC_HANDLER(EXT4_MB_MAX_TO_SCAN_NAME, max_to_scan);
@@ -2804,7 +2809,6 @@ static int ext4_mb_init_per_dev_proc(struct super_block *sb)
 	return 0;
 
 err_out:
-	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 	remove_proc_entry(EXT4_MB_GROUP_PREALLOC, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_STREAM_REQ, sbi->s_mb_proc);
 	remove_proc_entry(EXT4_MB_ORDER2_REQ, sbi->s_mb_proc);
@@ -2813,6 +2817,8 @@ err_out:
 	remove_proc_entry(EXT4_MB_STATS_NAME, sbi->s_mb_proc);
 	remove_proc_entry(devname, proc_root_ext4);
 	sbi->s_mb_proc = NULL;
+err_create_dir:
+	printk(KERN_ERR "EXT4-fs: Unable to create %s\n", devname);
 
 	return -ENOMEM;
 }
