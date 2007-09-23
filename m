From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] [PATCH] e2fsprogs: dblist iteration loop is unbreakable
Date: Sun, 23 Sep 2007 11:40:08 -0400
Message-ID: <20070923154008.GB26453@thunk.org>
References: <46F460D0.9020605@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: "Vladimir V. Saveliev" <vs@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36949 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXIWPkO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Sep 2007 11:40:14 -0400
Content-Disposition: inline
In-Reply-To: <46F460D0.9020605@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Sep 22, 2007 at 03:24:48AM +0300, Vladimir V. Saveliev wrote:
> 
> ext2fs_dblist_iterate breaks its iteration loop if callback's return value
> has set DBLIST_ABORT bit.
> If ext2fs_dblist_iterate is called by ext2fs_dblist_dir_iterate,
> the callback is db_dir_proc->ext2fs_process_dir_block, which returns BLOCK_ABORT
> if something goes wrong.
> BLOCK_ABORT is defined as 2, whereas DBLIST_ABORT is 1.
> As result ext2fs_dblist_iterate does not break the iteration loop when
> ext2fs_process_dir_block returns BLOCK_ABORT.

Hi, thanks for reporting this and sending a patch.  Unfortunately
there were a couple of problems with it.

First of all, please in the future remember to send your patches with
a Signed-off-by: header.

Secondly, DBLIST_ABORT and BLOCK_ABORT come from different number
spaces, and and so a fix like this:

> +		if ((ret & DBLIST_ABORT) || (ret == BLOCK_ABORT))
>  			return 0;

Raises an eyebrow right away.  (Also, the return convention with the
BLOCK_* flags are they are a bitfield, so you always compare them with
a boolean & operator: ret & BLOCK_ABORT).

The real issue is that the helper function db_dir_proc is supposed to
return flags of the form DBLIST_*, so it should have never called
ext2fs_process_dir_block() without translating its return codes.
HOWEVER, when I tried the obvious patch which mapped the return codes:

diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index f2e17a6..8571204 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -66,10 +66,14 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry *db_info,
                       void *priv_data)
 {
        struct dir_context      *ctx;
+       int                     ret;
 
        ctx = (struct dir_context *) priv_data;
        ctx->dir = db_info->ino;
        
-       return ext2fs_process_dir_block(fs, &db_info->blk,
-                                       db_info->blockcnt, 0, 0, priv_data);
+       ret = ext2fs_process_dir_block(fs, &db_info->blk,
+                                      db_info->blockcnt, 0, 0, priv_data);
+       if (ret & BLOCK_ABORT)
+               return DBLIST_ABORT;
+       return 0;
 }

It turns out this caused the regression test suite to break.  (Moral
of the story: ***Always run the regression test suite, since it will
catch things you might not have expected!***  Your original patch would
have failed the regression test for the same reason, by which I can
deduce that you didn't run "make check" as part of testing out your
patch.) 

The reason for the test failure is there are multiple reasons why
ext2fs_process_dir_block() might return BLOCK_ABORT.  It could do so
because the callback function (in this case search_dirent_proc() in
e2fsck/pass1b.c) has returned DIRENT_ABORT, but it can also do so
because a directory block was corrupted, or there was an I/O error
reading the directory block, etc., and in that case we don't want to
abort the entire dblist iteration.  The ultimate correct patch is
attached below, and has been checked into the e2fsprogs maint branch.

	 	 	    	     	     - Ted

commit f6341e9c70eb4e0ded51ca96aeaa79a72222c069
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Sep 23 11:39:24 2007 -0400

    ext2fs_dblist_dir_iterate: Fix ABORT propagation logic
    
    ext2fs_dblist_dir_iterate() calls ext2fs_dblist_iterate(), which calls
    ext2fs_process_dir_block(), which in turn calls the helper function
    db_dir_proc() which calls callback function passed into
    ext2fs_dblist_dir_iterate().  At each stage the conventions for
    signalling requests to abort the iteration or to signal errors
    changes, db_dir_proc() was not properly mapping the abort request back
    to ext2fs_dblist_iterate().
    
    Currently db_dir_proc() is ignoring errors (i/o errors or directory
    block corrupt errors) from ext2fs_process_dir_block(), since the main
    user of ext2fs_dblist_dir_iterate() is e2fsck, for which this is the
    correct behavior.  In the future ext2fs_dblist_dir_iterate() could
    take a flag which would cause it to abort if
    ext2fs_process_dir_block() returns an error; however, it's not clear
    how useful this would be since we don't have a way of signalling the
    exact nature of which block had the error, and the caller wouldn't
    have a good way of knowing what percentage of the directory block list
    had been processed.  Ultimately this may not be the best interface for
    applications that need that level of error reporting.
    
    Thanks to Vladimir V. Saveliev <vs@clusterfs.com> for pointing out
    this problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index f2e17a6..28a04c7 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -66,10 +66,15 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry *db_info,
 		       void *priv_data)
 {
 	struct dir_context	*ctx;
+	int			ret;
 
 	ctx = (struct dir_context *) priv_data;
 	ctx->dir = db_info->ino;
+	ctx->errcode = 0;
 	
-	return ext2fs_process_dir_block(fs, &db_info->blk,
-					db_info->blockcnt, 0, 0, priv_data);
+	ret = ext2fs_process_dir_block(fs, &db_info->blk,
+				       db_info->blockcnt, 0, 0, priv_data);
+	if ((ret & BLOCK_ABORT) && !ctx->errcode)
+		return DBLIST_ABORT;
+	return 0;
 }
