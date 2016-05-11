From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 1/2] direct-io: cleanup get_more_blocks()
Date: Wed, 11 May 2016 19:05:53 +0200
Message-ID: <20160511170553.GA7332@quack2.suse.cz>
References: <1462645910-23290-1-git-send-email-guaneryu@gmail.com>
 <x49y47h6cg2.fsf@segfault.boston.devel.redhat.com>
 <20160511132312.GD10350@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbcEKRF4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 13:05:56 -0400
Content-Disposition: inline
In-Reply-To: <20160511132312.GD10350@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-05-16 21:23:12, Eryu Guan wrote:
> On Tue, May 10, 2016 at 01:38:05PM -0400, Jeff Moyer wrote:
> > Look, I think this is all you need for the full fix:
> > 
> > diff --git a/fs/direct-io.c b/fs/direct-io.c
> > index 4720377..f66754e 100644
> > --- a/fs/direct-io.c
> > +++ b/fs/direct-io.c
> > @@ -639,8 +639,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
> >  		 */
> >  		create = dio->rw & WRITE;
> >  		if (dio->flags & DIO_SKIP_HOLES) {
> > -			if (sdio->block_in_file < (i_size_read(dio->inode) >>
> > -							sdio->blkbits))
> > +			if (fs_startblk < fs_count)

fs_count is number of blocks in the request so that is not correct...

> >  				create = 0;
> >  		}
> >  
> >  
> > Can you just test that?
> 
> I tested it and it did fix both of the issues for me. But it seems that
> it's a bit overkilled, in certain case block allocation should be
> allowed, but it still sets 'create' to 0.
> 
> For example, append writing 8k to a 4k sparse file (so offset is also
> 4k), on a 4k block size filesystem, fs_startblk(1) is smaller than
> fs_count(2), so it still sets 'create' to 0. But block allocation should
> be allowed in this case, and both the original code and my patch do so.
> 
> So I simplified my real fix to this (updates for comments not included):
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 4720377..0cace3e 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -639,8 +639,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
>                  */
>                 create = dio->rw & WRITE;
>                 if (dio->flags & DIO_SKIP_HOLES) {
> -                       if (sdio->block_in_file < (i_size_read(dio->inode) >>
> -                                                       sdio->blkbits))
> +                       if (fs_startblk <= ((i_size_read(dio->inode) - 1) >>
> +                                                       i_blkbits))
>                                 create = 0;

Yes, this is correct as far as I can tell.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
