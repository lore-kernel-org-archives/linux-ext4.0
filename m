From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: Mark the buffer as unmapped before reading the
	next quota block
Date: Mon, 2 Feb 2009 11:34:29 +0100
Message-ID: <20090202103429.GB7145@duck.suse.cz>
References: <ea11fea30902020204t7a2db3a7tbf3f0b8d22b20cce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>,
	cmm@us.ibm.com
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:60669 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751071AbZBBKeb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Feb 2009 05:34:31 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea30902020204t7a2db3a7tbf3f0b8d22b20cce@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 02-02-09 15:34:27, Manish Katiyar wrote:
> Hi Jan,
> 
> This is in continuation with the previous patch
> (http://patchwork.ozlabs.org/patch/20275/) . We also need to set the
> buffer as unmapped before reading the next block. I don't think quota
> files can have holes, but atleast for correctness, otherwise once we
> have read a block, tmp_bh is always mapped even for holes.
> 
> 
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
>  fs/ext2/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index da8bdea..b4e7633 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1328,6 +1328,7 @@ static ssize_t ext2_quota_read(struct
> super_block *sb, int type, char *data,
>  				sb->s_blocksize - offset : toread;
> 
>  		tmp_bh.b_state = 0;
> +		clear_buffer_mapped(&tmp_bh);
  I don't get this. When b_state is 0, then in particuler the buffer is not
mapped. So why clear the mapped bit explicitely?

>  		err = ext2_get_block(inode, blk, &tmp_bh, 0);
>  		if (err < 0)
>  			return err;

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
