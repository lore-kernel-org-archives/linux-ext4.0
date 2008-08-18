From: Theodore Tso <tytso@mit.edu>
Subject: Re: ENOSPC error returned too late
Date: Mon, 18 Aug 2008 09:30:46 -0400
Message-ID: <20080818133046.GA8184@mit.edu>
References: <E1KUhkt-0003yw-Sf@closure.thunk.org> <20080818093026.GA7808@skywalker> <20080818105140.GB7808@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60610 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbYHRNau (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 09:30:50 -0400
Content-Disposition: inline
In-Reply-To: <20080818105140.GB7808@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 04:21:40PM +0530, Aneesh Kumar K.V wrote:
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1628,6 +1628,9 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
>  		free_blocks =
>  			percpu_counter_sum_and_set(&sbi->s_freeblocks_counter);
>  #endif
> +	if (free_blocks <= root_blocks)
> +		/* we don't have free space */
> +		return 0;
>  	if (free_blocks - root_blocks < nblocks)
>  		return free_blocks - root_blocks;
>  	return nblocks;

Thanks, I'll try it out.  Given that ext4_fsblk_t is an unsigned long
(BTW, this is one of the reasons why the common coding style guide
dislikes typedefs; it hides this kind of errors), it's obviously a
good patch to add regardless of whether it solves are problem, since
if freeblocks < root_blocks, the following condition is going to do
the Wrong Thing.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted

