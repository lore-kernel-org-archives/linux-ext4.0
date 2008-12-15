From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V4 2/3] quota: Add quota claim and release reserved
	quota blocks operations
Date: Mon, 15 Dec 2008 14:40:16 +0100
Message-ID: <20081215134016.GD15464@duck.suse.cz>
References: <1229114860.7646.26.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38497 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751964AbYLONkS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2008 08:40:18 -0500
Content-Disposition: inline
In-Reply-To: <1229114860.7646.26.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Mingming,

  sorry I spoke to soon in my previous email. You tried to resolve the
issue with dquot_transfer(). I just thought it would belong to the first
patch...

On Fri 12-12-08 12:47:40, Mingming Cao wrote:
> quota: Add quota reservation claim and released operations
> 
> Reserved quota will be claimed at the block allocation time. Over-booked
> quota could be returned back with the release callback function.
> 
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
>  fs/dquot.c               |  101 +++++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/quota.h    |    4 +
>  include/linux/quotaops.h |   53 ++++++++++++++++++++++++
>  3 files changed, 153 insertions(+), 5 deletions(-)
> 
  <snip>

> Index: linux-2.6.28-rc2/fs/dquot.c
> ===================================================================
> --- linux-2.6.28-rc2.orig/fs/dquot.c	2008-12-12 12:20:45.000000000 -0800
> +++ linux-2.6.28-rc2/fs/dquot.c	2008-12-12 12:21:49.000000000 -0800
  <snip>

> @@ -1448,7 +1532,8 @@ int dquot_free_inode(const struct inode 
>   */
>  int dquot_transfer(struct inode *inode, struct iattr *iattr)
>  {
> -	qsize_t space;
> +	qsize_t space, cur_space;
> +	qsize_t rsv_space = 0;
>  	struct dquot *transfer_from[MAXQUOTAS];
>  	struct dquot *transfer_to[MAXQUOTAS];
>  	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
> @@ -1489,12 +1574,16 @@ int dquot_transfer(struct inode *inode, 
>  		}
>  	}
>  	spin_lock(&dq_data_lock);
> -	space = inode_get_bytes(inode);
> +	space = cur_space = inode_get_bytes(inode);
>  	/* Build the transfer_from list and check the limits */
>  	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
>  		if (transfer_to[cnt] == NODQUOT)
>  			continue;
>  		transfer_from[cnt] = inode->i_dquot[cnt];
> +		if (!rsv_space) {
> +			rsv_space = transfer_from[cnt]->dq_dqb.dqb_rsvspace;
> +			space += rsv_space;
  Hmm, but you cannot simply transfer all the reserved space from one user
to another. You have to transfer just the amount reserved for this inode
(i.e. EXT4_I(inode)->i_reserved_data_blocks +
EXT4_I(inode)->i_reserved_meta_blocks). The fact is this is not available
to quota code. One possibility is to store this number in VFS inode (which I
guess people would not like because it would increase every inode size by 8
bytes). So probably more plausible is to provide a callback so that quota
code can find out how much space this inode has reserved. This is not a
performance critical operation so the cost of the function call is
acceptable here IMO.

> +		}
>  		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
>  		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
>  		    warntype_to + cnt) == NO_QUOTA)
> @@ -1518,11 +1607,13 @@ int dquot_transfer(struct inode *inode, 
>  			warntype_from_space[cnt] =
>  				info_bdq_free(transfer_from[cnt], space);
>  			dquot_decr_inodes(transfer_from[cnt], 1);
> -			dquot_decr_space(transfer_from[cnt], space);
> +			dquot_decr_space(transfer_from[cnt], cur_space);
> +			dquot_free_reserved_space(transfer_from[cnt], rsv_space);
>  		}
>  
>  		dquot_incr_inodes(transfer_to[cnt], 1);
> -		dquot_incr_space(transfer_to[cnt], space);
> +		dquot_incr_space(transfer_to[cnt], cur_space);
> +		dquot_resv_space(transfer_to[cnt], rsv_space);
>  
>  		inode->i_dquot[cnt] = transfer_to[cnt];
>  	}

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
