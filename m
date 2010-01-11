From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/5] quota: decouple fs reserved space from quota reservation
Date: Mon, 11 Jan 2010 11:53:19 -0600
Message-ID: <4B4B658F.3020801@redhat.com>
References: <1261589276-1380-1-git-send-email-jack@suse.cz> <1261589276-1380-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: stable@kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0AKRzS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2010 12:55:18 -0500
In-Reply-To: <1261589276-1380-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> 
> Currently inode_reservation is managed by fs itself and this
> reservation is transfered on dquot_transfer(). This means what
> inode_reservation must always be in sync with
> dquot->dq_dqb.dqb_rsvspace. Otherwise dquot_transfer() will result
> in incorrect quota(WARN_ON in dquot_claim_reserved_space() will be
> triggered)
> This is not easy because of complex locking order issues
> for example http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> The patch introduce quota reservation field for each fs-inode
> (fs specific inode is used in order to prevent bloating generic
> vfs inode). This reservation is managed by quota code internally
> similar to i_blocks/i_bytes and may not be always in sync with
> internal fs reservation.
> 
> Also perform some code rearrangement:
> - Unify dquot_reserve_space() and dquot_reserve_space()
> - Unify dquot_release_reserved_space() and dquot_free_space()
> - Also this patch add missing warning update to release_rsv()
>   dquot_release_reserved_space() must call flush_warnings() as
>   dquot_free_space() does.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

...

> @@ -1734,7 +1761,7 @@ int dquot_transfer(struct inode *inode, struct
iattr *iattr)
>  	}
>  	spin_lock(&dq_data_lock);
>  	cur_space = inode_get_bytes(inode);
> -	rsv_space = dquot_get_reserved_space(inode);
> +	rsv_space = inode_get_rsv_space(inode);
>  	space = cur_space + rsv_space;
>  	/* Build the transfer_from list and check the limits */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {

...

>  /*
> + * inode_reserved_space is managed internally by quota, and protected by
> + * i_lock similar to i_blocks+i_bytes.
> + */
> +static qsize_t *inode_reserved_space(struct inode * inode)
> +{
> +	/* Filesystem must explicitly define it's own method in order to use
> +	 * quota reservation interface */
> +	BUG_ON(!inode->i_sb->dq_op->get_reserved_space);

Unless I'm missing something, this just broke quota for everyone
except ext4 ...

sys_chown
	...
		dquot_transfer
			inode_get_rsv_space
				inode_reserved_space

will BUG_ON ext3, we get there with (rightly) no ->get_reserved_space.

Or am I missing something?

-Eric
