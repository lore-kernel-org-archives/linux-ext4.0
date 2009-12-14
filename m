From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] quota: decouple fs reserved space from quota
 reservation. [V5]
Date: Mon, 14 Dec 2009 18:24:18 +0100
Message-ID: <20091214172418.GD4731@quack.suse.cz>
References: <1260793276-8511-1-git-send-email-dmonakhov@openvz.org>
 <1260793276-8511-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314AbZLNRzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 12:55:50 -0500
Content-Disposition: inline
In-Reply-To: <1260793276-8511-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 14-12-09 15:21:13, Dmitry Monakhov wrote:
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
> Changes from V4
>  - fixes and cleanups according to Jan's comments.
> Changes from V3:
>  - fix deadlock in dquota_alloc_space in journalled mode with nodelalloc
> Changes from V1:
>  - move qutoa_reservation field from vfs_inode to fs_inode
>  - account reservation in bytes instead of blocks.
  Looks good. I've just slightly updated changelog and below
typecast (doing just __dquot_free_space(inode, number, 1)) and merged the
patch to my tree.

> +void dquot_release_reserved_space(struct inode *inode, qsize_t number)
> +{
> +	return (void )__dquot_free_space(inode, number, 1);
> +
> +}

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
