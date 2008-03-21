From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: powerpc e2fsprogs and fast symlink
Date: Fri, 21 Mar 2008 00:40:28 -0500
Message-ID: <47E34A4C.2040805@redhat.com>
References: <20080319193801.GA16687@skywalker> <20080320074740.GA11891@skywalker> <47E34515.5070500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYCUFk5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 01:40:57 -0400
In-Reply-To: <47E34515.5070500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> Aneesh Kumar K.V wrote:
>
>   
>> The extent support on powerpc doesn't seems to work with e2fsprogs.
>> make check on e2fsprogs on powerpc gives
>>
>> f_extents: basic extents support: failed
>>   
>>     
> I see a few things wrong:
>
> Looks like swap_inode_full was incorrectly swapping the i_block
> data for extents, as well as incorrectly checking for the 
> EXTENTS flag on big-endian boxes.  Hmm maybe I need to think
> a little more about symlinks with the extent flag set...
>   
FWIW, here's a patch for these problems.  Still working on a clean
solution for the last one.

-Eric

Index: e2fsprogs/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs/lib/ext2fs/swapfs.c
@@ -147,6 +147,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
 			    int bufsize)
 {
 	unsigned i, has_data_blocks, extra_isize, attr_magic;
+	int has_extents = 0;
 	int islnk = 0;
 	__u32 *eaf, *eat;
 
@@ -172,12 +173,13 @@ void ext2fs_swap_inode_full(ext2_filsys 
 		has_data_blocks = ext2fs_inode_data_blocks(fs, 
 					   (struct ext2_inode *) t);
 	if (hostorder && (f->i_flags & EXT4_EXTENTS_FL))
-		has_data_blocks = 0;
+		has_extents = 1;
 	t->i_flags = ext2fs_swab32(f->i_flags);
-	if (hostorder && (t->i_flags & EXT4_EXTENTS_FL))
-		has_data_blocks = 0;
+	if (!hostorder && (t->i_flags & EXT4_EXTENTS_FL))
+		has_extents = 1;
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
-	if (!islnk || has_data_blocks ) {
+	/* extent data are swapped on access, not here */
+	if (!has_extents && (!islnk || has_data_blocks)) {
 		for (i = 0; i < EXT2_N_BLOCKS; i++)
 			t->i_block[i] = ext2fs_swab32(f->i_block[i]);



