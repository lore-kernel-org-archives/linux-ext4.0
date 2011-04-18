From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch v2 2/4] percpu_counter: delete dead code
Date: Sun, 17 Apr 2011 20:12:55 -0400
Message-ID: <20110418001255.GA19243@thunk.org>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
 <20110413080517.566936500@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cl@linux.com, tj@kernel.org, eric.dumazet@gmail.com,
	linux-ext4@vger.kernel.org
To: shaohua.li@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49319 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRANF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Apr 2011 20:13:05 -0400
Content-Disposition: inline
In-Reply-To: <20110413080517.566936500@sli10-conroe.sh.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'll take care of merging this patch via the ext4 tree.

     	       	  	       	     - Ted

On Wed, Apr 13, 2011 at 03:57:17PM +0800, shaohua.li@intel.com wrote:
> percpu_counter_sum_positive never returns negative.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  fs/ext4/balloc.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: linux/fs/ext4/balloc.c
> ===================================================================
> --- linux.orig/fs/ext4/balloc.c	2011-04-12 16:22:59.000000000 +0800
> +++ linux/fs/ext4/balloc.c	2011-04-13 13:23:01.000000000 +0800
> @@ -507,11 +507,6 @@ static int ext4_has_free_blocks(struct e
>  						EXT4_FREEBLOCKS_WATERMARK) {
>  		free_blocks  = percpu_counter_sum_positive(fbc);
>  		dirty_blocks = percpu_counter_sum_positive(dbc);
> -		if (dirty_blocks < 0) {
> -			printk(KERN_CRIT "Dirty block accounting "
> -					"went wrong %lld\n",
> -					(long long)dirty_blocks);
> -		}
>  	}
>  	/* Check whether we have space after
>  	 * accounting for current dirty blocks & root reserved blocks.
> 
> 
