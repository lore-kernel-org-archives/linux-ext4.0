From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] jbd2: Prevent panic for destroyed devices
Date: Sun, 13 Mar 2016 18:28:06 -0400
Message-ID: <20160313222806.GK29218@thunk.org>
References: <1455618965-26699-1-git-send-email-dmonakhov@openvz.org>
 <1455618965-26699-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39052 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbcCMW2I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 18:28:08 -0400
Content-Disposition: inline
In-Reply-To: <1455618965-26699-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 16, 2016 at 02:36:05PM +0400, Dmitry Monakhov wrote:
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 81e6226..f2760c8 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1333,6 +1333,18 @@ static int jbd2_write_superblock(journal_t *journal, int write_op)
>  	if (!(journal->j_flags & JBD2_BARRIER))
>  		write_op &= ~(REQ_FUA | REQ_FLUSH);
>  	lock_buffer(bh);
> +	/*
> +	 * Some disk drives may invalidate its page cache on failure
> +	 * so sbh becomes unmapped.
> +	 */
> +	if (!buffer_mapped(bh)) {

I think checking bh->bdev == NULL is a better check for this
condition.

> +		/* Disk dissapeared under us, there is nothing we can

Spelling nit: "disappeared"

> +		   do but complain */
> +		printk(KERN_ERR "JBD2: journal superblock was invalidated "
> +		       "for %s.\n", journal->j_devname);
> +		return -EIO;
> +	}
> +

This is missing a an "unlock_buffer(bh)" before we return.


>  	if (buffer_write_io_error(bh)) {
>  		/*
>  		 * Oh, dear.  A previous attempt to write the journal

		       	      		 	 - Ted
						 
