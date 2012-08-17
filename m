From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Far too long mount time
Date: Fri, 17 Aug 2012 09:55:06 -0400
Message-ID: <20120817135506.GC11439@thunk.org>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com>
 <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com>
 <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca>
 <1345126608.22142.59.camel@cwalton-XPS-8300>
 <20120816144219.GB29410@thunk.org>
 <20120816185337.GB31346@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Javier Marcet <jmarcet@gmail.com>,
	Linux Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	jpiszcz@lucidpixels.com
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45252 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab2HQNzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 09:55:14 -0400
Content-Disposition: inline
In-Reply-To: <20120816185337.GB31346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 02:53:37PM -0400, Theodore Ts'o wrote:
> This patch should solve the problem (as an alternative to reverting
> 8aeb00ff85a).
> 
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 603023b..055c65b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3129,6 +3129,10 @@ static int count_overhead(struct super_block *sb, ext4_group_t grp,
>  	ext4_group_t		i, ngroups = ext4_get_groups_count(sb);
>  	int			s, j, count = 0;
>  
> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> +		return (ext4_bg_has_super(sb, grp) + ext4_bg_num_gdb(sb, i) +
                                                                        ^^^

This should be "grp"; stupid typo on my part.

This patch with the fix-up will be pushed to Linus shortly and tagged
for the stable tree.

     	       	      	     	     	- Ted
