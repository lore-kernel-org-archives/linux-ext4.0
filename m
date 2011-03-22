From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't kfree uninitialized s_group_info members
Date: Mon, 21 Mar 2011 21:27:05 -0400
Message-ID: <20110322012705.GA3907@thunk.org>
References: <4D7958B3.8070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>, dame_eugene@mail.ru
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41105 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab1CVB1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 21:27:07 -0400
Content-Disposition: inline
In-Reply-To: <4D7958B3.8070309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 10, 2011 at 05:03:15PM -0600, Eric Sandeen wrote:
> Per kernel.org bugzilla #30872 we may call kfree on uninitialized
> members of the s_group_info array.  We can avoid this by kzalloc'ing
> the array, and only freeing them on the error path if they are
> non-zero.
> 
> This doesn't entirely solve the oops on mount if we fail down this
> path; failed_mount4: frees the sbi, for one, which gets referenced
> later in the failed mount paths - I haven't worked that out yet.
> 
> Reported-by: Eugene A. Shatokhin <dame_eugene@mail.ru>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to the ext4 patch tree, although I've dropped the second patch
hunk, since it's OK to call kfree on a NULL pointers:

> @@ -2412,7 +2412,8 @@ err_freebuddy:
>  		kmem_cache_free(cachep, ext4_get_group_info(sb, i));
>  	i = num_meta_group_infos;
>  	while (i-- > 0)
> -		kfree(sbi->s_group_info[i]);
> +		if (sbi->s_group_info[i])
> +			kfree(sbi->s_group_info[i]);
>  	iput(sbi->s_buddy_cache);
>  err_freesgi:
>  	kfree(sbi->s_group_info);

							- Ted
