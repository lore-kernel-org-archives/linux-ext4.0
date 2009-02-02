From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] : Remove incompatible pointer assignment warning in ext4 quota operations
Date: Mon, 2 Feb 2009 17:10:05 +0100
Message-ID: <20090202161005.GG19165@atrey.karlin.mff.cuni.cz>
References: <ea11fea30901272117j760a34e8w5df0ec1916632f3f@mail.gmail.com> <ea11fea30901272121x319aa2b3m2a5a5799b6df4d8a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55399 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZBBQKH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Feb 2009 11:10:07 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30901272121x319aa2b3m2a5a5799b6df4d8a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, Jan 28, 2009 at 10:47 AM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> > Below patch removes the following warning during compilation :
> >
> >  CC [M]  fs/ext4/super.o
> > fs/ext4/super.c:949: warning: initialization from incompatible pointer type
> >  LD [M]  fs/ext4/ext4.o
> 
> Sorry,
> 
> Tha correct patch is here.
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
  Looks fine to me.
Acked-by: Jan Kara <jack@suse.cz>

										Honza

> ---
>  fs/ext4/ext4.h  |    2 +-
>  fs/ext4/inode.c |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 3ab1a41..0164866 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
> *, int nrblocks);
>  extern int ext4_block_truncate_page(handle_t *handle,
>  		struct address_space *mapping, loff_t from);
>  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> -extern unsigned long long ext4_get_reserved_space(struct inode *inode);
> +extern qsize_t ext4_get_reserved_space(struct inode *inode);
> 
>  /* ioctl.c */
>  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6a316ec..6be09be 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -973,9 +973,9 @@ out:
>  	return err;
>  }
> 
> -unsigned long long ext4_get_reserved_space(struct inode *inode)
> +qsize_t ext4_get_reserved_space(struct inode *inode)
>  {
> -	unsigned long long total;
> +	qsize_t total;
> 
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	total = EXT4_I(inode)->i_reserved_data_blocks +
> -- 
> 1.5.4.3
> 
> Thanks -
> Manish
> 
> >
> >
> > Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> > ---
> >  fs/ext4/ext4.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 3ab1a41..0164866 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -1088,7 +1088,7 @@ extern int ext4_chunk_trans_blocks(struct inode
> > *, int nrblocks);
> >  extern int ext4_block_truncate_page(handle_t *handle,
> >                struct address_space *mapping, loff_t from);
> >  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
> > -extern unsigned long long ext4_get_reserved_space(struct inode *inode);
> > +extern qsize_t ext4_get_reserved_space(struct inode *inode);
> >
> >  /* ioctl.c */
> >  extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
> > --
> > 1.5.4.3
> >
> >
> > Thanks -
> > Manish
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
