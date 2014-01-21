From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/6] misc: fix resource leaks in e2fsprogs
Date: Tue, 21 Jan 2014 10:18:19 -0800
Message-ID: <20140121181819.GP9229@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062145.20507.54068.stgit@birch.djwong.org>
 <20140121072553.GB1819@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22657 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbaAUSSY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 13:18:24 -0500
Content-Disposition: inline
In-Reply-To: <20140121072553.GB1819@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:25:54PM +0800, Zheng Liu wrote:
> On Mon, Jan 20, 2014 at 10:21:45PM -0800, Darrick J. Wong wrote:
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It seems that we will free 'fn' in ext2fs_free_icount().

Oh, so it is.  Ignore this patch, please.

--D
> 
>   void ext2fs_free_icount(ext2_icount_t icount)
>   {
>           if (!icount)
>                   return;
>   
>           icount->magic = 0;
>           if (icount->list)
>                   ext2fs_free_mem(&icount->list);
>           if (icount->single)
>                   ext2fs_free_inode_bitmap(icount->single);
>           if (icount->multiple)
>                   ext2fs_free_inode_bitmap(icount->multiple);
>           if (icount->tdb)
>                   tdb_close(icount->tdb);
>           if (icount->tdb_fn) {
>                   unlink(icount->tdb_fn);
>                   free(icount->tdb_fn);
>           }
>   
>           ext2fs_free_mem(&icount);
>   }
> 
> Regards,
>                                                 - Zheng
> 
> > ---
> >  lib/ext2fs/icount.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > 
> > diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
> > index a3b20f0..7d1b3d5 100644
> > --- a/lib/ext2fs/icount.c
> > +++ b/lib/ext2fs/icount.c
> > @@ -198,6 +198,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
> >  	fd = mkstemp(fn);
> >  	if (fd < 0) {
> >  		retval = errno;
> > +		ext2fs_free_mem(&fn);
> >  		goto errout;
> >  	}
> >  	umask(save_umask);
> > @@ -216,6 +217,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
> >  	close(fd);
> >  	if (icount->tdb == NULL) {
> >  		retval = errno;
> > +		ext2fs_free_mem(&fn);
> >  		goto errout;
> >  	}
> >  	*ret = icount;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
