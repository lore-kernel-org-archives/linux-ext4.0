From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] FLEX_BG Kernel support v2.
Date: Wed, 12 Sep 2007 07:24:57 -0500
Message-ID: <20070912072457.35eeed8c@gara>
References: <20070912000701.10301.40946.stgit@toolssf2>
	<20070912072754.GE5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56737 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804AbXILMYw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Sep 2007 08:24:52 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l8CCOoNR025555
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 08:24:50 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8CCOp6i635884
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 08:24:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8CCOoji002231
	for <linux-ext4@vger.kernel.org>; Wed, 12 Sep 2007 08:24:50 -0400
In-Reply-To: <20070912072754.GE5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 12 Sep 2007 01:27:54 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Sep 11, 2007  19:07 -0500, Jose R. Santos wrote:
> > @@ -1248,13 +1248,17 @@ static int ext4_check_descriptors (struct super_block * sb)
> >  	ext4_fsblk_t inode_table;
> >  	struct ext4_group_desc * gdp = NULL;
> >  	int desc_block = 0;
> > +	int flexbg_bg = 0;
> >  	int i;
> >  
> > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > +		flexbg_flag = 1;
> 
> Umm, have you compiled this?  "int flexbg_bg" and "flexbg_flag"...

Compiled - Yes
Tested - Yes
Run "stg refresh" before sending the patch - No

-JRS

commit 27e75138890129895a5639f602fec564479583b3
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Wed Sep 12 06:56:58 2007 -0500

    FLEX_BG Kernel support v2.
    
    This feature relaxes check restrictions on where each block groups meta data is
    located within the storage media.  This allows for the allocation of bitmaps or
    inode tables outside the block group boundaries in cases where bad blocks forces
    us to look for new blocks which the owning block group can not satisfy.  This
    will also allow for new meta-data allocation schemes to improve performance and
    scalability.
    
    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4550b83..dbce81d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1248,13 +1248,17 @@ static int ext4_check_descriptors (struct super_block * sb)
 	ext4_fsblk_t inode_table;
 	struct ext4_group_desc * gdp = NULL;
 	int desc_block = 0;
+	int flexbg_flag = 0;
 	int i;
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		flexbg_flag = 1;
+
 	ext4_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
-		if (i == sbi->s_groups_count - 1)
+		if (i == sbi->s_groups_count - 1 || flexbg_flag)
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
@@ -1291,7 +1295,8 @@ static int ext4_check_descriptors (struct super_block * sb)
 				    i, inode_table);
 			return 0;
 		}
-		first_block += EXT4_BLOCKS_PER_GROUP(sb);
+		if (!flexbg_flag)
+			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 		gdp = (struct ext4_group_desc *)
 			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index cdee7aa..d53e167 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -702,13 +702,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
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
