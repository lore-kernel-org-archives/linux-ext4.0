From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove the duplicate set_buffer_mapped() for
 ext4_da_get_block_prep()
Date: Wed, 23 Mar 2011 14:05:45 -0400
Message-ID: <20110323180545.GA27946@thunk.org>
References: <1298360438-9521-1-git-send-email-feng.tang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Feng Tang <feng.tang@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49242 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1CWSFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 14:05:49 -0400
Content-Disposition: inline
In-Reply-To: <1298360438-9521-1-git-send-email-feng.tang@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, added to the ext4 patch tree.

						- Ted

On Tue, Feb 22, 2011 at 03:40:38PM +0800, Feng Tang wrote:
> The map_bh() called right before it already set the buffer_head to mapped.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  fs/ext4/inode.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9f7f9e4..6fe60f5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2597,7 +2597,6 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
>  		 * for partial write.
>  		 */
>  		set_buffer_new(bh);
> -		set_buffer_mapped(bh);
>  	}
>  	return 0;
>  }
> -- 
> 1.7.0.4
> 
