From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Silence warning in ext4_writepages()
Date: Wed, 3 Jul 2013 12:07:25 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1307031204000.3892@localhost.localdomain>
References: <1372788869-24456-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab3GCKHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jul 2013 06:07:39 -0400
In-Reply-To: <1372788869-24456-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2 Jul 2013, Jan Kara wrote:

> Date: Tue,  2 Jul 2013 20:14:29 +0200
> From: Jan Kara <jack@suse.cz>
> To: Ted Tso <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
> Subject: [PATCH] ext4: Silence warning in ext4_writepages()
> 
> The loop in mpage_map_and_submit_extent() is guaranteed to always run at
> least once since the caller of mpage_map_and_submit_extent() makes sure
> map->m_len > 0. So make that explicit using do-while instead of pure
> while which also silences the compiler warning about uninitialized 'err'
> variable.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0188e65..19a1643 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2163,7 +2163,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  
>  	mpd->io_submit.io_end->offset =
>  				((loff_t)map->m_lblk) << inode->i_blkbits;
> -	while (map->m_len) {
> +	do {
>  		err = mpage_map_one_extent(handle, mpd);
>  		if (err < 0) {
>  			struct super_block *sb = inode->i_sb;
> @@ -2201,7 +2201,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  		err = mpage_map_and_submit_buffers(mpd);
>  		if (err < 0)
>  			return err;
> -	}
> +	} while (map->m_len);
>  
>  	/* Update on-disk size after IO is submitted */
>  	disksize = ((loff_t)mpd->first_page) << PAGE_CACHE_SHIFT;
> 
