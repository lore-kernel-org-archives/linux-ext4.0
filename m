From: tytso@mit.edu
Subject: Re: [PATCH][BUG][TAKE2] ext4: unify each meaning of the offset in
 ext4_check_dir_entry calling from some functions.
Date: Tue, 2 Mar 2010 00:22:57 -0500
Message-ID: <20100302052257.GE6077@thunk.org>
References: <20100203161348.0bf98d58.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52285 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab0CBFXA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Mar 2010 00:23:00 -0500
Content-Disposition: inline
In-Reply-To: <20100203161348.0bf98d58.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2010 at 04:13:48PM +0900, Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> "offset" of the error message of ext4_check_dir_entry() might change the
> meaning by the caller. There are 2 meanings:
> - "File offset"
>   called by:
>    ext4_readdir, htree_dirblock_to_tree, search_dirblock, ext4_dx_find_entry,
>    empty_dir
> - "Buffer offset"
>   called by:
>    add_dirent_to_buf, ext4_delete_entry
> 
> The best way to solve this problem is to change the meaning of
> "Buffer offset" into "File offset" but it is not easy.

It would be desirable for this to be made consistent, but a physical
block number plus the buffer offset is actually much less useful for
someone trying to find the bad directory entry.

So what I've checked into the ext4 patch queue prints both the
physical block nubmer and the relative offset, as well as the
passed-in offset which in many cases is the file offset.

	  	       	       	     	- Ted

commit e5a2233178ebf8b6538dc19a0dcf721d11590ea0
Author: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Date:   Tue Mar 2 00:21:35 2010 -0500

    ext4: make "offset" consistent in ext4_check_dir_entry()
    
    The callers of ext4_check_dir_entry() usually pass in the "file
    offset" (ext4_readdir, htree_dirblock_to_tree, search_dirblock,
    ext4_dx_find_entry, empty_dir), but a few callers (add_dirent_to_buf,
    ext4_delete_entry) only pass in the buffer offset.
    
    To accomodate those last two (which would be hard to fix otherwise),
    this patch changes ext4_check_dir_entry() to print the physical block
    number and the relative offset as well as the passed-in offset.
    
    Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 0e0bef3..29857dd 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -84,9 +84,11 @@ int ext4_check_dir_entry(const char *function, struct inode *dir,
 
 	if (error_msg != NULL)
 		__ext4_error(dir->i_sb, function,
-			"bad entry in directory #%lu: %s - "
-			"offset=%u, inode=%u, rec_len=%d, name_len=%d",
-			dir->i_ino, error_msg, offset,
+			"bad entry in directory #%lu: %s - block=%llu"
+			"offset=%u(%u), inode=%u, rec_len=%d, name_len=%d",
+			dir->i_ino, error_msg, 
+			(unsigned long long) bh->b_blocknr,     
+			(unsigned) (offset%bh->b_size), offset,
 			le32_to_cpu(de->inode),
 			rlen, de->name_len);
 	return error_msg == NULL ? 1 : 0;
