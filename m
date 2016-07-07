From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [RFC PATCH] ext4: validate number of meta clusters in group
Date: Thu, 7 Jul 2016 22:10:40 +0200
Message-ID: <577EB740.10502@oracle.com>
References: <57766AE1.1040508@oracle.com>
 <20160702074903.GA4914@birch.djwong.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020804070408000007080700"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcGGUKu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 16:10:50 -0400
In-Reply-To: <20160702074903.GA4914@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020804070408000007080700
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 07/02/2016 09:49 AM, Darrick J. Wong wrote:
> On Fri, Jul 01, 2016 at 03:06:41PM +0200, Vegard Nossum wrote:
>> Hi,
>>
>> I've found that sbi->s_es->s_reserved_gdt_blocks is not validated before
>> being used, so e.g. a value of 25600 will overflow the buffer head and
>> corrupt random kernel memory (I've observed 20+ different stack traces
>> due to this bug! many of them long after the code has finished).
>
> This function merely initializes a bitmap block once ext4 decides to start
> using the block group, which could be a long time after mount...
>
>> The following patch fixes it for me:
>>
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 3020fd7..1ea5054 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -208,6 +208,9 @@ static int ext4_init_block_bitmap(struct super_block
>> *sb,
>>   	memset(bh->b_data, 0, sb->s_blocksize);
>>
>>   	bit_max = ext4_num_base_meta_clusters(sb, block_group);
>> +	if ((bit_max >> 3) >= bh->b_size)
>> +		return -EFSCORRUPTED;
>> +
>>   	for (bit = 0; bit < bit_max; bit++)
>>   		ext4_set_bit(bit, bh->b_data);
>>
>> However, I think there are potentially more bugs later in this function
>> where offsets are not validated so it needs to be reviewed carefully.
>>
>> Another question is whether we should do the validation earlier, e.g. in
>> ext4_fill_super(). I'm not too familiar with the code, but maybe
>> something like the attached patch would be better? It does seem to fix
>> the issue as well.
>
> ...whereas superblock fields such as s_reserved_gdt_blocks ought to be
> checked (and -EFSCORRUPTED'ed) at mount time.  Since we know that BG 0
> has everything (superblock, old school gdt tables, inodes), maybe we
> should make mount check that ext4_num_base_meta_clusters() >
> NBBY * fs->block_size?
>
> (Kinda surprised ext4 doesn't already do this...)

I ran into a second problem (this time it was num_clusters_in_group()
returning a bogus value) with the same symptoms (random memory
corruptions), the new attached patch fixes both problems by checking the
values at mount time.

I'm using (bit_max >> 3) >= sb->s_blocksize which should be equivalent
to what you suggested (num_clusters() > NBBY * fs->block_size).


Vegard

--------------020804070408000007080700
Content-Type: text/x-patch;
 name="0001-ext4-validate-number-of-clusters-in-group.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ext4-validate-number-of-clusters-in-group.patch"

>From 2e2fc0c40d604e88748bba8d440763249c55b391 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@oracle.com>
Date: Fri, 1 Jul 2016 15:03:39 +0200
Subject: [PATCH] ext4: validate number of clusters in group

I've found that sbi->s_es->s_reserved_gdt_blocks is not validated before
being used, so e.g. a value of 25600 will overflow the buffer head and
corrupt random kernel memory (I've observed 20+ different stack traces
due to these bugs, many of them long after the code has finished).

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/balloc.c | 12 +++++-------
 fs/ext4/ext4.h   |  4 ++++
 fs/ext4/super.c  | 19 +++++++++++++++++++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3020fd7..5a5c679 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -22,8 +22,6 @@
 
 #include <trace/events/ext4.h>
 
-static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
-					    ext4_group_t block_group);
 /*
  * balloc.c contains the blocks allocation and deallocation routines
  */
@@ -155,8 +153,8 @@ static unsigned ext4_num_overhead_clusters(struct super_block *sb,
 	return num_clusters;
 }
 
-static unsigned int num_clusters_in_group(struct super_block *sb,
-					  ext4_group_t block_group)
+unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					ext4_group_t block_group)
 {
 	unsigned int blocks;
 
@@ -237,7 +235,7 @@ static int ext4_init_block_bitmap(struct super_block *sb,
 	 * the blocksize * 8 ( which is the size of bitmap ), set rest
 	 * of the block bitmap to 1
 	 */
-	ext4_mark_bitmap_end(num_clusters_in_group(sb, block_group),
+	ext4_mark_bitmap_end(ext4_num_clusters_in_group(sb, block_group),
 			     sb->s_blocksize * 8, bh->b_data);
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
@@ -251,7 +249,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	return num_clusters_in_group(sb, block_group) - 
+	return ext4_num_clusters_in_group(sb, block_group) -
 		ext4_num_overhead_clusters(sb, block_group, gdp);
 }
 
@@ -817,7 +815,7 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
  * This function returns the number of file system metadata clusters at
  * the beginning of a block group, including the reserved gdt blocks.
  */
-static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+unsigned ext4_num_base_meta_clusters(struct super_block *sb,
 				     ext4_group_t block_group)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b84aa1ca..c325c95 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2270,6 +2270,10 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
 extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
+extern unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+					    ext4_group_t block_group);
+extern unsigned int ext4_num_clusters_in_group(struct super_block *sb,
+					       ext4_group_t block_group);
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 					 ext4_fsblk_t goal,
 					 unsigned int flags,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 563555e..05ec0a7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3641,6 +3641,25 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 	sbi->s_groups_count = blocks_count;
+
+	for (i = 0; i < sbi->s_groups_count; ++i) {
+		int bit_max;
+
+		bit_max = ext4_num_base_meta_clusters(sb, i);
+		if ((bit_max >> 3) >= sb->s_blocksize) {
+			ext4_msg(sb, KERN_WARNING, "meta cluster base for "
+				"group %u exceeds block size", i);
+			goto failed_mount;
+		}
+
+		bit_max = ext4_num_clusters_in_group(sb, i);
+		if ((bit_max >> 3) >= sb->s_blocksize) {
+			ext4_msg(sb, KERN_WARNING, "clusters in "
+				"group %u exceeds block size", i);
+			goto failed_mount;
+		}
+	}
+
 	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
-- 
1.9.1


--------------020804070408000007080700--
