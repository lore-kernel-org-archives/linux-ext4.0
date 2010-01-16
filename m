From: tytso@mit.edu
Subject: Re: [PATCH v4 2/3] ext4: use ext4_get_block_write in buffer write
Date: Fri, 15 Jan 2010 21:17:12 -0500
Message-ID: <20100116021712.GA25273@thunk.org>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
 <1263583812-21355-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiaying Zhang <jiayingz@google.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47354 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0APClw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Jan 2010 21:41:52 -0500
Content-Disposition: inline
In-Reply-To: <1263583812-21355-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 02:30:11PM -0500, Theodore Ts'o wrote:
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 05eca81..dd58020 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -304,4 +304,28 @@ static inline int ext4_should_writeback_data(struct inode *inode)
>  	return 0;
>  }
>  
> +/*
> + * This function controls whether or not we should try to go down the
> + * dioread_nolock code paths, which makes it safe to avoid taking
> + * i_mutex for direct I/O reads.  This only works for extent-based
> + * files, and it doesn't work for nobh or if data journaling is
> + * enabled, since the dioread_nolock code uses b_private to pass
> + * information back to the I/O completion handler, and this conflicts
> + * with the jbd's use of b_private.
> + */
> +static inline int ext4_should_dioread_nolock(struct inode *inode)
> +{
> +	if (!test_opt(inode->i_sb, DIOREAD_NOLOCK))
> +		return 0;
> +	if (test_opt(inode->i_sb, NOBH))
> +		return 0;
> +	if (!S_ISREG(inode->i_mode))
> +		return 0;
> +	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)

Oops, this was an embarassing typo.   This should have been:

+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))

Thanks to Jiaying for pointing this out.

						- Ted
