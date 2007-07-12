From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Thu, 12 Jul 2007 10:09:06 -0500
Message-ID: <20070712100906.2e2afb9c@gara>
References: <20070710112307.34c2ba5c@rx8>
 <20070711041213.GH6417@schatzie.adilger.int>
 <20070711003004.531c9307@naruto>
 <20070711221425.GH19456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52035 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbXGLPKo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 11:10:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l6CF5C2O019253
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 11:05:12 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6CFAgGI191596
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 09:10:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6CFAgrm027369
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 09:10:42 -0600
In-Reply-To: <20070711221425.GH19456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 11 Jul 2007 18:14:25 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Jul 11, 2007 at 12:30:04AM -0500, Jose R. Santos wrote:
> > Right now what I've done is allocate the bitmaps and inode tables at the
> > beginning of each group of 64 BG.  Still need to work on fsck since just
> > removing the restriction on were the bitmaps and inode table are
> > located still gives me errors of uninitialized inodes with dtime set.
> > Seems like fsck still expect inode information to be located at
> > specific locations within the disk.
> 
> Can you send me the patch which you were playing with?  I might be
> able to help you with this.  It should be pretty straightforward to
> remove the constraint on the inode table location.  

Here is the kernel piece.

-JRS

---
 fs/ext4/super.c         |    3 	3 +	0 -	0 !
 include/linux/ext4_fs.h |    4 	3 +	1 -	0 !
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2007-07-11 15:34:58.000000000 -0500
+++ linux-2.6/fs/ext4/super.c	2007-07-11 16:19:08.000000000 -0500
@@ -1271,6 +1271,9 @@ static int ext4_check_descriptors (struc
 
 	ext4_debug ("Checking group descriptors");
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		return 1;
+
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
 		if (i == sbi->s_groups_count - 1)
Index: linux-2.6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.orig/include/linux/ext4_fs.h	2007-07-11 15:34:58.000000000 -0500
+++ linux-2.6/include/linux/ext4_fs.h	2007-07-12 09:58:51.000000000 -0500
@@ -698,13 +698,15 @@ static inline int ext4_valid_inum(struct
 #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT| \
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
