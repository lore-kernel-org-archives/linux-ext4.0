From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/49] create_inode: clean up return mess in
 do_write_internal
Date: Tue, 11 Mar 2014 13:41:31 -0700
Message-ID: <20140311204131.GA31864@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065404.30585.9687.stgit@birch.djwong.org>
 <9EBDB4AF-4901-4416-ACC4-6F25233316BD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26598 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336AbaCKUli (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 16:41:38 -0400
Content-Disposition: inline
In-Reply-To: <9EBDB4AF-4901-4416-ACC4-6F25233316BD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 02:30:02PM -0600, Andreas Dilger wrote:
> On Mar 11, 2014, at 12:54 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > do_write_internal returns errno when ext2 library calls fail; since
> > errno only reflects the outcome of the last C library call, this will
> > result in confused callers.  Eliminate the naked return since
> > this results in an undefined return value.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > misc/create_inode.c |   17 ++++++++++-------
> > 1 file changed, 10 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/misc/create_inode.c b/misc/create_inode.c
> > index cf4a58f..647480c 100644
> > --- a/misc/create_inode.c
> > +++ b/misc/create_inode.c
> > @@ -353,14 +353,14 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
> > 	if (retval == 0) {
> > 		com_err(__func__, 0, "The file '%s' already exists\n", dest);
> > 		close(fd);
> > -		return errno;
> > +		return retval;
> > 	}
> 
> This seems a bit strange.  It looks like an error return, but it will
> actually return "0" since this branch is only entered if retval == 0.
> Should this return an explicit error value here?

You're right; maybe we should return EXT2_ET_FILE_EXISTS or something?

I don't really think feeding zero to the com_err() is a great idea either.
Zheng, do you have an opinion about which error code to return?

--D
> 
> Cheers, Andreas
> 
> > 	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
> > 	if (retval) {
> > 		com_err(__func__, retval, 0);
> > 		close(fd);
> > -		return errno;
> > +		return retval;
> > 	}
> > #ifdef DEBUGFS
> > 	printf("Allocated inode: %u\n", newfile);
> > @@ -372,7 +372,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
> > 		if (retval) {
> > 			com_err(__func__, retval, "while expanding directory");
> > 			close(fd);
> > -			return errno;
> > +			return retval;
> > 		}
> > 		retval = ext2fs_link(current_fs, cwd, dest, newfile,
> > 					EXT2_FT_REG_FILE);
> > @@ -412,12 +412,15 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
> > 	if ((retval = ext2fs_write_new_inode(current_fs, newfile, &inode))) {
> > 		com_err(__func__, retval, "while creating inode %u", newfile);
> > 		close(fd);
> > -		return errno;
> > +		return retval;
> > 	}
> > 	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
> > 		retval = ext2fs_inline_data_init(current_fs, newfile);
> > -		if (retval)
> > -			return;
> > +		if (retval) {
> > +			com_err("copy_file", retval, 0);
> > +			close(fd);
> > +			return retval;
> > +		}
> > 	}
> > 	if (LINUX_S_ISREG(inode.i_mode)) {
> > 		if (statbuf.st_blocks < statbuf.st_size / S_BLKSIZE) {
> > @@ -434,7 +437,7 @@ errcode_t do_write_internal(ext2_ino_t cwd, const char *src, const char *dest)
> > 	}
> > 	close(fd);
> > 
> > -	return 0;
> > +	return retval;
> > }
> > 
> > /* Copy files from source_dir to fs */
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


