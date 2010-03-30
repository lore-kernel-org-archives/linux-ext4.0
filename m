From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix quota accounting in case of fallocate
Date: Tue, 30 Mar 2010 18:27:49 +0400
Message-ID: <87pr2ldguy.fsf@openvz.org>
References: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:6441 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0C3O2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Mar 2010 10:28:01 -0400
In-Reply-To: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Tue, 30 Mar 2010 18:24:35 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> allocated_meta_data is already included in 'used' variable.
Since 2.6.33 is also affected the patch have to be pushed to
stable IMHO.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bec222c..bf989fb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1110,7 +1110,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  		 */
>  		if (allocated_meta_blocks)
>  			dquot_claim_block(inode, allocated_meta_blocks);
> -		dquot_release_reservation_block(inode, mdb_free + used);
> +		dquot_release_reservation_block(inode, mdb_free + used -
> +			allocated_meta_blocks);
>  	}
>  
>  	/*
