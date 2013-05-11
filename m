From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH]mke2fs: Calculate journal blocks just after fs initialize
Date: Sat, 11 May 2013 09:12:13 +0530
Message-ID: <1368243733-1600-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-ext4@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44358 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3EKDmr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 May 2013 23:42:47 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq12so3349215pab.12
        for <linux-ext4@vger.kernel.org>; Fri, 10 May 2013 20:42:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ashish Sangwan <a.sangwan@samsung.com>

We can calculate journal blocks as soon as blocksize is set.
It will help to figure out wrong journal blocks count earlier.
This will save some un-necessary initialization.

Without patch output =>
mke2fs /dev/sdc1 -J size=1048576
mke2fs 1.42.7 (21-Jan-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
61312 inodes, 244936 blocks
12246 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=251658240
8 block groups
32768 blocks per group, 32768 fragments per group
7664 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done

The requested journal size is 268435456 blocks; it must be
between 1024 and 10240000 blocks.  Aborting.


With patch output =>
mke2fs /dev/sdc1 -J size=1048576
mke2fs 1.42.7 (21-Jan-2013)

The requested journal size is 268435456 blocks; it must be
between 1024 and 10240000 blocks.  Aborting.

Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 misc/mke2fs.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index bbf477a..0232053 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2407,6 +2407,12 @@ int main (int argc, char *argv[])
 		com_err(device_name, retval, _("while setting up superblock"));
 		exit(1);
 	}
+
+	/* Calculate journal blocks */
+	if (!journal_device && ((journal_size) ||
+		(fs_param.s_feature_compat &
+		 EXT3_FEATURE_COMPAT_HAS_JOURNAL)))
+		journal_blocks = figure_journal_size(journal_size, fs);
 	fs->progress_ops = &ext2fs_numeric_progress_ops;
 
 	/* Check the user's mkfs options for metadata checksumming */
@@ -2683,8 +2689,6 @@ int main (int argc, char *argv[])
 	} else if ((journal_size) ||
 		   (fs_param.s_feature_compat &
 		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
-		journal_blocks = figure_journal_size(journal_size, fs);
