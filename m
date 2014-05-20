From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 2/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 20 May 2014 10:45:07 -0600
Message-ID: <537B8693.4000904@hp.com>
References: <1400589949-25595-1-git-send-email-jack@suse.cz> <1400589949-25595-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54301 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaETQrM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 May 2014 12:47:12 -0400
In-Reply-To: <1400589949-25595-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/20/2014 06:45 AM, Jan Kara wrote:
> +	if (dirty) {
> +		err = ext4_handle_dirty_super(handle, sb);
> +		rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> +		if (!err)
> +			err = rc;
> +		if (err) {
> +			/*
> +			 * We have to remove inode from in-memory list if
> + 			 * addition to on disk orphan list failed. Stray orphan
> +			 * list entries can cause panics at unmount time.
> +			 */
> +			mutex_lock(&sbi->s_orphan_lock);
> +			list_del(&EXT4_I(inode)->i_orphan);
> +			mutex_unlock(&sbi->s_orphan_lock);
> +		}
> +	}

Sorry Jan, I just noticed this.

I don't believe you could this optimization either.  Since you drop the s_oprhan_lock in between, you essentially have an interval where there is a stray in-memory orphan and could cause a panic as the comment above mentioned.

As for comments regarding ext4_mark_iloc() optimization, in your case since you are holding the i_mutex, should not that prevent the inode from being reclaimed?

Thanks,
Mak.

