From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: add rb_tree cache to struct ext4_group_info
Date: Sun, 28 Mar 2010 10:03:19 -0500
Message-ID: <4BAF6FB7.601@redhat.com>
References: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab0C1PD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Mar 2010 11:03:28 -0400
In-Reply-To: <h2tac8f92701003280211p70c2dbcpac77b16fb27deb79@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jing zhang wrote:
> From: Jing Zhang <zj.barak@gmail.com>
> 
> Date: Sun Mar 28 17:09:33     2010
> 
> rb_tree cache is added to struct ext4_group_info at minor cost.

Please include a reason for the change in the commit message,
so that in the future people don't have to figure out for
themselves why a change was made.  It also helps reviewers.  :)

...

> @@ -4376,7 +4384,7 @@ ext4_mb_free_metadata(handle_t *handle,
>  		if (block < entry->start_blk)
>  			n = &(*n)->rb_left;
>  		else if (block >= (entry->start_blk + entry->count))
> -			n = &(*n)->rb_right;
> +			n = &(*n)->rb_right, left = 0;
>  		else {
>  			ext4_grp_locked_error(sb, e4b->bd_group, __func__,
>  					"Double free of blocks %d (%d %d)",

I think it's better if you don't use that style, but instead:

 		else if (block >= (entry->start_blk + entry->count)) {
			n = &(*n)->rb_right;
			left = 0;
		} else {
			...
