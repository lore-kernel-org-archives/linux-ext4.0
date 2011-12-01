From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
Date: Thu, 01 Dec 2011 15:39:09 +0800
Message-ID: <4ED72F1D.7070207@tao.ma>
References: <20111201070052.GA29708@july>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:60064 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751582Ab1LAHj0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 02:39:26 -0500
In-Reply-To: <20111201070052.GA29708@july>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Kyungmin,
On 12/01/2011 03:00 PM, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Now trim information doesn't stored at disk so every boot time. it's cleared.
> and do the trim all disk groups.
> But assume that it's already trimmed at previous time so don't need to trim it again. So set the intial state as trimmed.
sorry, I don't get your meaning here.
Why can we assume that the group is already trimmed since it isn't
stored in the disk?

Thanks
Tao
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2d8be8..97ef342 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
>  		goto err;
>  	}
>  	mark_page_accessed(page);
> +
> +	/*
> +	 * TRIM information is not stored at disk so set the initial
> +	 * state as trimmed. Since previous time it's already trimmed all
> +	 */
> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
>  err:
>  	ext4_mb_put_buddy_page_lock(&e4b);
>  	return ret;

