From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Tue, 17 Jul 2007 20:40:25 -0500
Message-ID: <469D6F89.9090500@redhat.com>
References: <1182331988.9772.7.camel@garfield> <469D3271.8050908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbXGRBka (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2007 21:40:30 -0400
In-Reply-To: <469D3271.8050908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:

> Kalpak Shah wrote:
> ...
>
>   
>> Index: e2fsprogs-1.39/lib/ext2fs/inode.c
>> ===================================================================
>> --- e2fsprogs-1.39.orig/lib/ext2fs/inode.c      2007-06-19 22:31:21.000000000 -0700
>> +++ e2fsprogs-1.39/lib/ext2fs/inode.c   2007-06-20 01:06:18.017788976 -0700
>> @@ -471,6 +471,7 @@ errcode_t ext2fs_get_next_inode_full(ext
>>                 scan->bytes_left -= scan->inode_size - extra_bytes;
>>
>>  #ifdef EXT2FS_ENABLE_SWAPFS
>> +               memset(inode, 0, bufsize);
>>                 if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
>>                     (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
>>                         ext2fs_swap_inode_full(scan->fs,
>> @@ -485,6 +486,7 @@ errcode_t ext2fs_get_next_inode_full(ext
>>                 scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
>>         } else {
>>  #ifdef EXT2FS_ENABLE_SWAPFS
>> +               memset(inode, 0, bufsize);
>>                 if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
>>                     (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
>>                         ext2fs_swap_inode_full(scan->fs,
>>     
>
>
> This is making "make check" fail for me on ppc64:
> (git-bisect claims 1ed49d2c2ab7fdb02158d5feeb86288ece7eb17c is the first
> bad commit...)  Any ideas?  Looking into it now.
>
>   
Ok, I think this is the deal... ext2fs_get_next_inode_full zeros out 
"inode" which is the "t" (->to) inode that is sent to
ext2fs_swap_inode_full, with hostorder==0, which does this:

        if (hostorder)  /* "from" in hostorder */
                has_data_blocks = ext2fs_inode_data_blocks(fs,
                                           (struct ext2_inode *) f);
        t->i_blocks = ext2fs_swab32(f->i_blocks);
        if (!hostorder) /* "to" (will be) in hostorder, zeroed by caller */
                /* ext2fs_inode_data_blocks checks t->i_file_acl! */
                has_data_blocks = ext2fs_inode_data_blocks(fs,
                                           (struct ext2_inode *) t);
        t->i_flags = ext2fs_swab32(f->i_flags);
        t->i_file_acl = ext2fs_swab32(f->i_file_acl); /* finally set! */

so in the !hostorder case, ext2fs_inode_data_blocks checks t->i_file_acl,
which has been cleared by the caller, and isn't set until *after* it is
tested in ext2fs_get_next_inode_full.

So I'm a little lost in the order of things here, but it looks to me
like we need to set t->i_file_acl before we try to test 
ext2fs_inode_data_blocks for that "to" inode...

Seems fair?  At least it passes "make check" on both x86 and ppc
with the following change...

-Eric

---------

set t->i_file_acl before we test it in 
ext2fs_inode_data_blocks

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40.2/lib/ext2fs/swapfs.c
@@ -150,6 +150,7 @@ void ext2fs_swap_inode_full(ext2_filsys 
 	t->i_dtime = ext2fs_swab32(f->i_dtime);
 	t->i_gid = ext2fs_swab16(f->i_gid);
 	t->i_links_count = ext2fs_swab16(f->i_links_count);
+	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
 	if (hostorder)
 		has_data_blocks = ext2fs_inode_data_blocks(fs, 
 					   (struct ext2_inode *) f);
@@ -158,7 +159,6 @@ void ext2fs_swap_inode_full(ext2_filsys 
 		has_data_blocks = ext2fs_inode_data_blocks(fs, 
 					   (struct ext2_inode *) t);
 	t->i_flags = ext2fs_swab32(f->i_flags);
-	t->i_file_acl = ext2fs_swab32(f->i_file_acl);
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
 	if (!islnk || has_data_blocks ) {


 		for (i = 0; i < EXT2_N_BLOCKS; i++)
