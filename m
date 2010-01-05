From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: fsstress-induced corruption reproduced
Date: Tue, 5 Jan 2010 11:47:28 +0530
Message-ID: <20100105061728.GA7868@skywalker.linux.vnet.ibm.com>
References: <E1NQNIB-0006gT-1r@closure.thunk.org>
 <4B424BE4.3030605@redhat.com>
 <4B427507.40004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41813 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0AEGRe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Jan 2010 01:17:34 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp05.in.ibm.com (8.14.3/8.13.1) with ESMTP id o056HUqm024288
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jan 2010 11:47:30 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o056HUfY2244768
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jan 2010 11:47:30 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o056HUY9015511
	for <linux-ext4@vger.kernel.org>; Tue, 5 Jan 2010 11:47:30 +0530
Content-Disposition: inline
In-Reply-To: <4B427507.40004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 04, 2010 at 05:08:55PM -0600, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Theodore Ts'o wrote:
> >> One of the things which has been annoying me for a while now is a
> >> hard-to-reproduce xfsqa failure in test #13 (fsstress), which causes the
> >> a test failure because the file system found to be inconsistent:
> >>
> >> Inode NNN, i_blocks is X, should be Y.
> > 
> > Interesting, this apparently has gotten much worse since 2.6.32.
> > 
> > I wrote an xfstests reproducer, and couldn't hit it on .32; hit it right
> > off on 2.6.33-rc2.
> > 
> > Probably should find out why ;) I'll go take a look.
> 
> commit d21cd8f163ac44b15c465aab7306db931c606908
> Author: Dmitry Monakhov <dmonakhov@openvz.org>
> Date:   Thu Dec 10 03:31:45 2009 +0000
> 
>     ext4: Fix potential quota deadlock
> 
> seems to be the culprit.
> 
> (unfortunately this means that the error we saw before is something
> -else- to be fixed, yet)  Anyway ...
> 
> This is because we used to do this in ext4_mb_mark_diskspace_used() :
> 
>         /*
>          * Now reduce the dirty block count also. Should not go negative
>          */
>         if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
>                 /* release all the reserved blocks if non delalloc */
>                 percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> reserv_blks);
>         else {
>                 percpu_counter_sub(&sbi->s_dirtyblocks_counter,
>                                                 ac->ac_b_ex.fe_len);
>                 /* convert reserved quota blocks to real quota blocks */
>                 vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
> 	}
> 
> i.e. the vfs_dq_claim_block was conditional based on
> EXT4_MB_DELALLOC_RESERVED... and the testcase did not go that way,
> because we had already preallocated the blocks.
> 
> But with the above quota deadlock commit it's not unconditional
> anymore in ext4_da_update_reserve_space and we always call
> vfs_dq_claim_block which over-accounts.
> 

It is still conditional right ? We call ext4_da_update_reserve_space
only if EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE  is set . That will
happen only in case of delayed allocation. I guess the problem is
same as what Ted stated. But i am not sure why we are able to reproduce
it much easily on 2.6.33-rc2.


> Of course with the above commit, we have no allocation context in
> ext4_da_update_reserve_space... that's all long gone so we can't key
> on that anymore.
> 
> However, I think the following change will fix it; I'll run it through
> xfstests later on and be sure nothing else regresses.
> 
> -Eric
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5352db1..28cd8d8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1257,9 +1257,10 @@ int ext4_get_blocks(handle_t *handle, struct
> inode *inode, sector_t block,
>          * if the caller is from delayed allocation writeout path
>          * we have already reserved fs blocks for allocation
>          * let the underlying get_block() function know to
> -        * avoid double accounting
> +        * avoid double accounting.  Ditto for prealloc blocks.
>          */
> -       if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
> +       if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE ||
> +           flags & EXT4_GET_BLOCKS_UNINIT_EXT)
>                 EXT4_I(inode)->i_delalloc_reserved_flag = 1;
>         /*
>          * We need to check for EXT4 here because migrate
> 


But we need to do quota update during fallocate call. Doing the above
will result we not doing that. We would will also get block accounting
wrong because we now won't be doing ext4_claim_free_blocks for fallocate.

I guess what we need is to make sure that if we have any buffer_head mapping
the same block range allocated via fallocate and if they are marked BH_Delay
we need to clear the delay flag and update the block reservation. Later during
writepage we will find these buffer_heads mapped/non-delay and will do the right thing.

-aneesh
