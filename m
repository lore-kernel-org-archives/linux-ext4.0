From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] ext4: Fix warning in ext4_evict_inode()
Date: Wed, 10 Jul 2013 11:46:09 -0700
Message-ID: <20130710184609.GA23061@roeck-us.net>
References: <1373399484-10406-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f68.google.com ([209.85.160.68]:62123 "EHLO
	mail-pb0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3GJSqK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jul 2013 14:46:10 -0400
Received: by mail-pb0-f68.google.com with SMTP id jt11so4010882pbb.7
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jul 2013 11:46:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373399484-10406-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 09:51:24PM +0200, Jan Kara wrote:
> The following race can lead to ext4_evict_inode() seeing i_ioend_count
> > 0 and thus triggering a sanity check warning:
> 
>         CPU1                                    CPU2
> ext4_end_bio()                          ext4_evict_inode()
>   ext4_finish_bio()
>     end_page_writeback();
>                                           truncate_inode_pages()
>                                             evict page
>                                         WARN_ON(i_ioend_count > 0);
>   ext4_put_io_end_defer()
>     ext4_release_io_end()
>       dec i_ioend_count
> 
> This is possible use-after-free bug since we decrement i_ioend_count in
> possibly released inode.
> 
> Since i_ioend_count is used only for sanity checks one possible solution
> would be to just remove it but for now I'd like to keep those sanity
> checks to help debugging the new ext4 writeback code.
> 
> This patch changes ext4_end_bio() to call ext4_put_io_end_defer() before
> ext4_finish_bio() in the shortcut case when unwritten extent conversion
> isn't needed. In that case we don't need the io_end so we are safe to
> drop it early.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jan Kara <jack@suse.cz>

I tried hard to reproduce the problem with this patch applied, but it just
didn't happen. While that is of course not proof that the problem is gone,
feel free to add

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

> ---
>  fs/ext4/page-io.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
>  Ted, this should fix the warning spotted by Guenter.
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 48786cd..d63cc5e 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -308,6 +308,7 @@ ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
>  	return io_end;
>  }
>  
> +/* BIO completion function for page writeback */
>  static void ext4_end_bio(struct bio *bio, int error)
>  {
>  	ext4_io_end_t *io_end = bio->bi_private;
> @@ -318,18 +319,6 @@ static void ext4_end_bio(struct bio *bio, int error)
>  	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = 0;
>  
> -	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
> -		/*
> -		 * Link bio into list hanging from io_end. We have to do it
> -		 * atomically as bio completions can be racing against each
> -		 * other.
> -		 */
> -		bio->bi_private = xchg(&io_end->bio, bio);
> -	} else {
> -		ext4_finish_bio(bio);
> -		bio_put(bio);
> -	}
> -
>  	if (error) {
>  		struct inode *inode = io_end->inode;
>  
> @@ -341,7 +330,24 @@ static void ext4_end_bio(struct bio *bio, int error)
>  			     (unsigned long long)
>  			     bi_sector >> (inode->i_blkbits - 9));
>  	}
> -	ext4_put_io_end_defer(io_end);
> +
> +	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
> +		/*
> +		 * Link bio into list hanging from io_end. We have to do it
> +		 * atomically as bio completions can be racing against each
> +		 * other.
> +		 */
> +		bio->bi_private = xchg(&io_end->bio, bio);
> +		ext4_put_io_end_defer(io_end);
> +	} else {
> +		/*
> +		 * Drop io_end reference early. Inode can get freed once
> +		 * we finish the bio.
> +		 */
> +		ext4_put_io_end_defer(io_end);
> +		ext4_finish_bio(bio);
> +		bio_put(bio);
> +	}
>  }
>  
>  void ext4_io_submit(struct ext4_io_submit *io)
> -- 
> 1.8.1.4
> 
> 
