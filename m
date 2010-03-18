From: tytso@mit.edu
Subject: Re: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Thu, 18 Mar 2010 13:46:29 -0400
Message-ID: <20100318174629.GK8256@thunk.org>
References: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51485 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0CRRqy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Mar 2010 13:46:54 -0400
Content-Disposition: inline
In-Reply-To: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>  		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
> @@ -3811,6 +3813,12 @@ repeat:
>  		list_del(&pa->u.pa_tmp_list);
>  		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
>  	}
> +	if (! list_empty(&list)) {
> +		if (occurs++ < 2)
> +			goto best_efforts;
> +		else
> +			BUG();
> +	}
>  	if (ac)
>  		kmem_cache_free(ext4_ac_cachep, ac);
>  }

Hmm, I'm not sure that BUG() is appropriate here.  If there is an
I/O error reading the block bitmap, #1, retrying isn't going to help,
and #2, bringing down the entire system just because of an I/O error
in reading the block bitmap doesn't seem right.

Right now, if there is a problem, we just end up leaving the
preallocated list on the inode.  Does that cause problems later on
down the line which you have observed?

					- Ted


