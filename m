From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/49] misc: fix header complaints and resource leaks in
 e2fsprogs
Date: Fri, 14 Mar 2014 12:23:34 -0700
Message-ID: <20140314192334.GE9070@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065553.30585.86527.stgit@birch.djwong.org>
 <20140314135350.GN8282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25496 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaCNTXk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2014 15:23:40 -0400
Content-Disposition: inline
In-Reply-To: <20140314135350.GN8282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2014 at 09:53:50AM -0400, Theodore Ts'o wrote:
> On Mon, Mar 10, 2014 at 11:55:53PM -0700, Darrick J. Wong wrote:
> > Fix a few minor bugs that cppcheck complained about.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied with the following changes.  It looks like cppcheck complained
> with another false positive in ext2fs_create_icount_tdb().  The
> filename is copied in icount->tdb_fn, and so adding a call to
> ext2fs_free_mem() will actually result in a double-free bug, since
> ext2fs_free_icount() will take care of releasing the memory.  Also,
> perhaps just as importantly, it will take care of deleting the
> temporary file created by mkstemp() first.
> 
> I did keep the first ext2fs_free_mem() and moved setting
> icount->tdb_fn down by a bit just to avoid a potential bug if
> mkstemp() fails, and there is a valid file of the form *-icount-XXXXXX
> that the user would be unhappy with us deleting.  Pedantic, perhaps,
> since it would probably never happen, but it's good to be 100%
> correct.  :-)

Ok, thanks for fixing the mistakes.  I was ignorant of the putenv thing. :/

--D
> 
> 					- Ted
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 11c2693..b39383d 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1016,7 +1016,6 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  			strcat(newpath, oldpath);
>  		}
>  		putenv(newpath);
> -		free(newpath);
>  	}
>  #ifdef CONFIG_JBD_DEBUG
>  	jbd_debug = getenv("E2FSCK_JBD_DEBUG");
> diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
> index 7d1b3d5..5e1f5c6 100644
> --- a/lib/ext2fs/icount.c
> +++ b/lib/ext2fs/icount.c
> @@ -193,7 +193,6 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
>  		goto errout;
>  	uuid_unparse(fs->super->s_uuid, uuid);
>  	sprintf(fn, "%s/%s-icount-XXXXXX", tdb_dir, uuid);
> -	icount->tdb_fn = fn;
>  	save_umask = umask(077);
>  	fd = mkstemp(fn);
>  	if (fd < 0) {
> @@ -201,6 +200,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
>  		ext2fs_free_mem(&fn);
>  		goto errout;
>  	}
> +	icount->tdb_fn = fn;
>  	umask(save_umask);
>  	/*
>  	 * This is an overestimate of the size that we will need; the
> @@ -217,7 +217,6 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
>  	close(fd);
>  	if (icount->tdb == NULL) {
>  		retval = errno;
> -		ext2fs_free_mem(&fn);
>  		goto errout;
>  	}
>  	*ret = icount;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
