From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/49] create_inode: clean up return mess in
 do_write_internal
Date: Tue, 11 Mar 2014 23:24:30 -0400
Message-ID: <20140312032430.GA23182@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065404.30585.9687.stgit@birch.djwong.org>
 <9EBDB4AF-4901-4416-ACC4-6F25233316BD@dilger.ca>
 <20140311204131.GA31864@birch.djwong.org>
 <20140311210853.GK2190@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40193 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbaCLDYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 23:24:35 -0400
Content-Disposition: inline
In-Reply-To: <20140311210853.GK2190@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 05:08:53PM -0400, Theodore Ts'o wrote:
> On Tue, Mar 11, 2014 at 01:41:31PM -0700, Darrick J. Wong wrote:
> > > This seems a bit strange.  It looks like an error return, but it will
> > > actually return "0" since this branch is only entered if retval == 0.
> > > Should this return an explicit error value here?
> > 
> > You're right; maybe we should return EXT2_ET_FILE_EXISTS or something?
> 
> EXT2_ET_FILE_EXISTS sounds good to me.

Thanks, applied, with the following change:

diff --git a/misc/create_inode.c b/misc/create_inode.c
index 647480c..fb6b800 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -351,9 +351,8 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
 
 	retval = ext2fs_namei(current_fs, root, cwd, dest, &newfile);
 	if (retval == 0) {
-		com_err(__func__, 0, "The file '%s' already exists\n", dest);
 		close(fd);
-		return retval;
+		return EXT2_ET_FILE_EXISTS;
 	}
 
 	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
