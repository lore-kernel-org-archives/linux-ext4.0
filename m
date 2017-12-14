From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 5/5] Fix minor typos in libext2fs documentation.
Date: Wed, 13 Dec 2017 23:13:13 -0800
Message-ID: <14508570e78e912db761692fef0dfa21d6b8177a.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33436 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdLNHOx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:53 -0500
Received: by mail-pf0-f196.google.com with SMTP id y89so3049802pfk.0
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:41 -0800 (PST)
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 doc/libext2fs.texinfo | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index 7ce74ba..1c3731f 100644
--- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -164,7 +164,7 @@ using @code{ext2fs_flush}.
 
 Most libext2fs functions take a filesystem handle of type
 @code{ext2_filsys}.  A filesystem handle is created either by opening
-an existing function using @code{ext2fs_open}, or by initializing a new
+an existing filesystem using @code{ext2fs_open}, or by initializing a new
 filesystem using @code{ext2fs_initialize}.
 
 @deftypefun errcode_t ext2fs_open (const char *@var{name}, int @var{flags}, int @var{superblock}, int @var{block_size}, io_manager @var{manager}, ext2_filsys *@var{ret_fs})
@@ -186,7 +186,7 @@ filesystem.  Normally this is determined automatically from the
 filesystem superblock.  If @var{block_size} is non-zero, it must match
 the block size found in the superblock, or the error
 @code{EXT2_ET_UNEXPECTED_BLOCK_SIZE} will be returned.  The
-@var{block_size} parameter is also used to help fund the superblock when
+@var{block_size} parameter is also used to help find the superblock when
 @var{superblock} is non-zero.
 
 The @var{flags} argument contains a bitmask of flags which control how
@@ -472,7 +472,7 @@ via @var{got}.
 @deftypefun errcode_t ext2fs_file_write (ext2_file_t @var{file}, const void *@var{buf}, unsigned int @var{nbytes}, unsigned int *@var{written})
 Write @var{wanted} bytes of data from the buffer @var{buf} to the
 current file position of @var{file}.  The number of bytes that was 
-actually written is returned via @var{got}.
+actually written is returned via @var{written}.
 @end deftypefun
 
 @c ----------------------------------------------------------------------
@@ -739,20 +739,20 @@ contain valid block entries.
 
 @deftypefun errcode_t ext2fs_read_dir_block (ext2_filsys @var{fs}, blk_t @var{block}, void *@var{buf})
 
-This function reads a directory block, performing any necessary
+This function reads a directory block, performing
 byte swapping if necessary.
 @end deftypefun
 
 @deftypefun errcode_t ext2fs_write_dir_block (ext2_filsys @var{fs}, blk_t @var{block}, void *@var{buf})
 
-This function writes a directory block, performing any necessary
+This function writes a directory block, performing
 byte swapping if necessary.
 @end deftypefun
 
 @deftypefun errcode_t ext2fs_new_dir_block (ext2_filsys @var{fs}, ext2_ino_t @var{dir_ino}, ext2_ino_t @var{parent_ino}, char **@var{block})
 
 This function creates a new directory block in @var{block}.  If
-@var{dir_ino} is non-zero, then @var{dir_info} and @var{parent_ino} is used
+@var{dir_ino} is non-zero, then @var{dir_ino} and @var{parent_ino} are used
 to initialize directory entries for @file{.} and @file{..}, respectively.
 @end deftypefun
 
@@ -1157,7 +1157,7 @@ trying to turn an inode number into a pathname.
 
 @deftypefun errcode_t ext2fs_init_dblist (ext2_filsys @var{fs}, ext2_dblist *@var{ret_dblist})
 
-Creates a dblist data structure and return it in @var{ret_dblist}.
+Creates a dblist data structure and returns it in @var{ret_dblist}.
 @end deftypefun
 
 @deftypefun void ext2fs_free_dblist (ext2_dblist @var{dblist})
@@ -1234,7 +1234,7 @@ Frees an icount structure.
 
 @deftypefun errcode_t ext2fs_icount_fetch (ext2_icount_t @var{icount}, ext2_ino_t @var{ino}, __u16 *@var{ret})
 
-Returns in @var{ret} fetches the count for a particular inode @var{ino}.
+Returns in @var{ret} the count for a particular inode @var{ino}.
 @end deftypefun
 
 @deftypefun errcode_t ext2fs_icount_increment (ext2_icount_t @var{icount}, ext2_ino_t @var{ino}, __u16 *@var{ret})
-- 
2.7.4
