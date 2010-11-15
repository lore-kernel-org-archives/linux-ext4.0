From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH]  V2 jbd2_stats_proc_init wrong place.
Date: Mon, 15 Nov 2010 10:59:01 -0600
Message-ID: <4CE166D5.60308@sandeen.net>
References: <1289510598-15315-1-git-send-email-sheng.yang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	ext4 development <linux-ext4@vger.kernel.org>
To: yangsheng <sheng.yang@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-28-21.usfamily.net ([64.131.28.21]:37684 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682Ab0KOQ7D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Nov 2010 11:59:03 -0500
In-Reply-To: <1289510598-15315-1-git-send-email-sheng.yang@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/11/10 3:23 PM, yangsheng wrote:
>  The jbd2_stats_proc_init() was placed on wrong location in
>  jbd2_journal_init_dev().  This may cause /proc/fs/jdb2/<dev>/*
>  cannot be created when using external journal device.
> ---
>  fs/jbd2/journal.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)

adding linux-ext4 to cc:

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 13b0a92..a435710 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -897,9 +897,18 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
>  	if (!journal)
>  		return NULL;
>  
> +	journal->j_dev = bdev;
> +	journal->j_fs_dev = fs_dev;
> +	journal->j_blk_offset = start;
> +	journal->j_maxlen = len;
> +	bdevname(journal->j_dev, journal->j_devname);
> +	p = journal->j_devname;
> +	while ((p = strchr(p, '/')))
> +		*p = '!';
> +	jbd2_stats_proc_init(journal);
> +
>  	/* journal descriptor can store up to n blocks -bzzz */
>  	journal->j_blocksize = blocksize;
> -	jbd2_stats_proc_init(journal);
>  	n = journal->j_blocksize / sizeof(journal_block_tag_t);
>  	journal->j_wbufsize = n;
>  	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
> @@ -908,14 +917,6 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
>  			__func__);
>  		goto out_err;
>  	}
> -	journal->j_dev = bdev;
> -	journal->j_fs_dev = fs_dev;
> -	journal->j_blk_offset = start;
> -	journal->j_maxlen = len;
> -	bdevname(journal->j_dev, journal->j_devname);
> -	p = journal->j_devname;
> -	while ((p = strchr(p, '/')))
> -		*p = '!';
>  
>  	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
>  	if (!bh) {

