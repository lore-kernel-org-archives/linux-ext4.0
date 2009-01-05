From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 05 Jan 2009 23:50:39 +0100
Message-ID: <49628EBF.2040805@ph.tum.de>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050300090503040107020907"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:38390 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbZAEWsX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 17:48:23 -0500
In-Reply-To: <20090105213938.GG8939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050300090503040107020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Theodore Tso wrote:
> On Mon, Jan 05, 2009 at 09:50:13PM +0100, Thiemo Nagel wrote:
>> I have chosen unsigned long for the sole reason to avoid truncation in  
>> the assignment
>>
>> db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
>> 	   EXT4_DESC_PER_BLOCK(sb);
>>
>> where the operands on the right side are of type unsigned long and  
>> ext4_group_t (which is typedef unsigned long), so I don't think to make  
>> db_count an unsigned long is hurting anything.
> 
> Err, no.  ext4_group_t is typedef'ed to be an unsigned int.  

fs/ext4/ext4_i.h, line 34:
typedef unsigned long ext4_group_t;

> And there
> are plenty of places in both the kernel and userspace code where the
> number of groups is assumed to a quantity that can be held in a 2**32
> bit field.  This isn't a problem, because normally the number of
> blocks per group is fs->blocksize*8.  So for a 4k block filesystem,
> the number of blocks per group is 32768, or 2**15.  So that means an
> effective limit of 2**47 blocks before we overflow 2**32 block group
> type width, and with 4k blocks, that means a max volume size of 512
> petabytes.   
> 
>> But maybe it's not desireable to allow filesystems which are mountable  
>> on x86_64 but not on x86_32?  Then a different solution would be to  
>> enforce s_groups_count < (1<<31).
> 
> I'd say enforce s_groups_count < 2**32, because that's the limit we
> have everywhere else.

Fine.

I had another look at the kmalloc() call:  It's not a problem because 
s_groups_count is divided by s_desc_per_block, which always is larger 
than the pointer size.

I have updated the

Patch: fix null pointer dereference on mount

Enforce 1 <= s_groups_count <= 2**32 - s_desc_per_block to avoid invalid 
memory accesses later in the code.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>


--------------050300090503040107020907
Content-Type: text/plain;
 name="null_deref.patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="null_deref.patch2"

--- linux-2.6.28-orig/fs/ext4/super.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/fs/ext4/super.c	2009-01-05 23:22:28.000000000 +0100
@@ -1873,8 +1873,8 @@
 	char *cp;
 	int ret = -EINVAL;
 	int blocksize;
-	int db_count;
-	int i;
+	unsigned int db_count;
+	unsigned int i;
 	int needs_recovery, has_huge_files;
 	__le32 features;
 	__u64 blocks_count;
@@ -2145,9 +2145,11 @@
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-	/* ensure blocks_count calculation below doesn't sign-extend */
-	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
-	    le32_to_cpu(es->s_first_data_block) + 1) {
+	/*
+	 * ensure blocks_count calculation below doesn't sign-extend
+	 * and after do_div() still blocks_count > 0
+	 */
+	if (ext4_blocks_count(es) < le32_to_cpu(es->s_first_data_block) + 1) {
 		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
 		       "first data block %u, blocks per group %lu\n",
 			ext4_blocks_count(es),
@@ -2160,6 +2162,15 @@
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	sbi->s_groups_count = blocks_count;
+	if (sbi->s_groups_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
+		printk(KERN_WARNING "EXT4-fs: groups count too large: %lu "
+		       "(block count %llu, first data block %u, blocks per group %lu)\n",
+			sbi->s_groups_count,
+			ext4_blocks_count(es),
+			le32_to_cpu(es->s_first_data_block),
+			EXT4_BLOCKS_PER_GROUP(sb));
+		goto failed_mount;
+	}
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
 	sbi->s_group_desc = kmalloc(db_count * sizeof(struct buffer_head *),

--------------050300090503040107020907--
