From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Check for return value from sb_set_blocksize
Date: Wed, 9 Jan 2008 23:51:15 +0530
Message-ID: <20080109182115.GB11852@skywalker>
References: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1199898469-10369-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:36789 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916AbYAISVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 13:21:23 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09ILIic019644
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 23:51:18 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09ILIRH1052902
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 23:51:18 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09ILHQh018523
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 18:21:18 GMT
Content-Disposition: inline
In-Reply-To: <1199898469-10369-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Updated patch. The earlier patch did multiple brelse() during failed
mount case.


ext4: Check for return value from sb_set_blocksize

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

sb_set_blocksize validates whether the specfied block size can be used by
the file system. Make sure we fail mounting the file system if the
blocksize specfied cannot be used.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/super.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)


diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 10330eb..f9a9ef1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1793,7 +1793,6 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	unsigned long def_mount_opts;
 	struct inode *root;
 	int blocksize;
-	int hblock;
 	int db_count;
 	int i;
 	int needs_recovery;
@@ -1958,20 +1957,16 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	hblock = bdev_hardsect_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
-		/*
-		 * Make sure the blocksize for the filesystem is larger
-		 * than the hardware sectorsize for the machine.
-		 */
-		if (blocksize < hblock) {
-			printk(KERN_ERR "EXT4-fs: blocksize %d too small for "
-			       "device blocksize %d.\n", blocksize, hblock);
+
+		/* Validate the filesystem blocksize */
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
+					blocksize);
 			goto failed_mount;
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = sb_bread(sb, logical_sb_block);
