From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 37/62] jbd: remove the second argument of
 k[un]map_atomic()
Date: Mon, 28 Nov 2011 15:15:43 +0100
Message-ID: <20111128141543.GB6366@quack.suse.cz>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-38-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Cong Wang <amwang@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1K1OPo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 09:15:44 -0500
Content-Disposition: inline
In-Reply-To: <1322371662-26166-38-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 27-11-11 13:27:17, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>
  Acked-by: Jan Kara <jack@suse.cz>

										Honza

> ---
>  fs/jbd/journal.c     |   12 ++++++------
>  fs/jbd/transaction.c |    4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index fea8dd6..de8ae3e 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -328,7 +328,7 @@ repeat:
>  		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
>  	}
>  
> -	mapped_data = kmap_atomic(new_page, KM_USER0);
> +	mapped_data = kmap_atomic(new_page);
>  	/*
>  	 * Check for escaping
>  	 */
> @@ -337,7 +337,7 @@ repeat:
>  		need_copy_out = 1;
>  		do_escape = 1;
>  	}
> -	kunmap_atomic(mapped_data, KM_USER0);
> +	kunmap_atomic(mapped_data);
>  
>  	/*
>  	 * Do we need to do a data copy?
> @@ -354,9 +354,9 @@ repeat:
>  		}
>  
>  		jh_in->b_frozen_data = tmp;
> -		mapped_data = kmap_atomic(new_page, KM_USER0);
> +		mapped_data = kmap_atomic(new_page);
>  		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
> -		kunmap_atomic(mapped_data, KM_USER0);
> +		kunmap_atomic(mapped_data);
>  
>  		new_page = virt_to_page(tmp);
>  		new_offset = offset_in_page(tmp);
> @@ -368,9 +368,9 @@ repeat:
>  	 * copying, we can finally do so.
>  	 */
>  	if (do_escape) {
> -		mapped_data = kmap_atomic(new_page, KM_USER0);
> +		mapped_data = kmap_atomic(new_page);
>  		*((unsigned int *)(mapped_data + new_offset)) = 0;
> -		kunmap_atomic(mapped_data, KM_USER0);
> +		kunmap_atomic(mapped_data);
>  	}
>  
>  	set_bh_page(new_bh, new_page, new_offset);
> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
> index 7e59c6e..e59a112 100644
> --- a/fs/jbd/transaction.c
> +++ b/fs/jbd/transaction.c
> @@ -712,9 +712,9 @@ done:
>  			    "Possible IO failure.\n");
>  		page = jh2bh(jh)->b_page;
>  		offset = offset_in_page(jh2bh(jh)->b_data);
> -		source = kmap_atomic(page, KM_USER0);
> +		source = kmap_atomic(page);
>  		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
> -		kunmap_atomic(source, KM_USER0);
> +		kunmap_atomic(source);
>  	}
>  	jbd_unlock_bh_state(bh);
>  
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
