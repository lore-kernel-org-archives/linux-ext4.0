From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] libext2fs : Fix typo in function names in libext2fs.texinfo
Date: Wed, 16 Jul 2008 00:38:40 +0530
Message-ID: <ea11fea30807151208m419892b3md4893612aa86b6f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: linux-ext4@vger.kernel.org, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:7920 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbYGOTIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 15:08:42 -0400
Received: by ti-out-0910.google.com with SMTP id b6so2746821tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:08:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the function names mentioned in libext2fs documentation.

==================================================================

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 doc/libext2fs.texinfo |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/doc/libext2fs.texinfo b/doc/libext2fs.texinfo
index e93a555..549d66e 100644
--- a/doc/libext2fs.texinfo
+++ b/doc/libext2fs.texinfo
@@ -561,7 +561,7 @@ and return to the caller.

 @deftypefun errcode_t ext2fs_block_iterate2 (ext2_filsys @var{fs},
ext2_ino_t @var{ino}, int @var{flags}, char *@var{block}_buf, int
(*func)(ext2_filsys @var{fs}, blk_t *@var{blocknr}, e2_blkcnt_t
@var{blockcnt}, blk_t @var{ref_blk}, int  @var{ref_offset}, void
*@var{private}), void *@var{private})

-This function is much like @code{ext2fs_block_iterate2}, except that the
+This function is much like @code{ext2fs_block_iterate}, except that the
 @var{blockcnt} type is a 64-bit signed quantity, to support larger
 files, and the addition of the @var{ref_blk} and @var{ref_offset}
 arguments passed to the callback function, which identify the location
@@ -590,7 +590,7 @@ inode structure.
 Returns 0 if @var{ino} is a directory, and @code{ENOTDIR} if it is not.
 @end deftypefun

-@deftypefun int ext2_inode_has_valid_blocks (struct ext2_inode *@var{inode})
+@deftypefun int ext2fs_inode_has_valid_blocks (struct ext2_inode *@var{inode})

 Returns 1 if the inode's block entries actually valid block entries, and
 0 if not.  Inodes which represent devices and fast symbolic links do not
@@ -1186,7 +1186,7 @@ intended for debugging and testing use only.
 @deftypefun errcode_t ext2fs_check_desc (ext2_filsys @var{fs})
 @end deftypefun

-@deftypefun errcode_t ext2_get_num_dirs (ext2_filsys @var{fs},
ext2_ino_t *@var{ret_num_dirs})
+@deftypefun errcode_t ext2fs_get_num_dirs (ext2_filsys @var{fs},
ext2_ino_t *@var{ret_num_dirs})
 @end deftypefun


-- 
1.5.4.3


==================================================================


Thanks -
Manish
