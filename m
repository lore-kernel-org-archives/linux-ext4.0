From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Tue, 17 Jul 2007 16:19:45 -0500
Message-ID: <469D3271.8050908@redhat.com>
References: <1182331988.9772.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	TheodoreTso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXGQVY6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2007 17:24:58 -0400
In-Reply-To: <1182331988.9772.7.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah wrote:
...

> Index: e2fsprogs-1.39/lib/ext2fs/inode.c
> ===================================================================
> --- e2fsprogs-1.39.orig/lib/ext2fs/inode.c      2007-06-19 22:31:21.000000000 -0700
> +++ e2fsprogs-1.39/lib/ext2fs/inode.c   2007-06-20 01:06:18.017788976 -0700
> @@ -471,6 +471,7 @@ errcode_t ext2fs_get_next_inode_full(ext
>                 scan->bytes_left -= scan->inode_size - extra_bytes;
> 
>  #ifdef EXT2FS_ENABLE_SWAPFS
> +               memset(inode, 0, bufsize);
>                 if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
>                     (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
>                         ext2fs_swap_inode_full(scan->fs,
> @@ -485,6 +486,7 @@ errcode_t ext2fs_get_next_inode_full(ext
>                 scan->scan_flags &= ~EXT2_SF_BAD_EXTRA_BYTES;
>         } else {
>  #ifdef EXT2FS_ENABLE_SWAPFS
> +               memset(inode, 0, bufsize);
>                 if ((scan->fs->flags & EXT2_FLAG_SWAP_BYTES) ||
>                     (scan->fs->flags & EXT2_FLAG_SWAP_BYTES_READ))
>                         ext2fs_swap_inode_full(scan->fs,


This is making "make check" fail for me on ppc64:
(git-bisect claims 1ed49d2c2ab7fdb02158d5feeb86288ece7eb17c is the first
bad commit...)  Any ideas?  Looking into it now.

--- ./f_clear_xattr/expect.1    2007-06-30 12:58:35.000000000 +0000
+++ f_clear_xattr.1.log 2007-07-17 19:48:17.000000000 +0000
@@ -1,10 +1,10 @@
 Pass 1: Checking inodes, blocks, and sizes
-Inode 14, i_blocks is 2, should be 0.  Fix? yes
-
 Inode 12, i_blocks is 4, should be 2.  Fix? yes

 Inode 13, i_blocks is 2, should be 0.  Fix? yes

+Inode 14, i_blocks is 2, should be 0.  Fix? yes
+
 Inode 15, i_blocks is 4, should be 2.  Fix? yes

 Pass 2: Checking directory structure
@@ -17,6 +17,9 @@
 i_file_acl for inode 14 (/symlink) is 22, should be zero.
 Clear? yes

+Symlink /symlink (inode #14) is invalid.
+Clear? yes
+
 i_file_acl for inode 15 (/long-symlink) is 23, should be zero.
 Clear? yes

@@ -34,5 +37,5 @@


 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 15/16 files (0.0% non-contiguous), 22/100 blocks
+test_filesys: 14/16 files (0.0% non-contiguous), 22/100 blocks
 Exit status is 1
--- ./f_clear_xattr/expect.2    2007-06-30 12:58:35.000000000 +0000
+++ f_clear_xattr.2.log 2007-07-17 19:48:17.000000000 +0000
@@ -3,5 +3,5 @@
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 15/16 files (0.0% non-contiguous), 22/100 blocks
+test_filesys: 14/16 files (0.0% non-contiguous), 22/100 blocks
 Exit status is 0
