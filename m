From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Fri, 18 Dec 2009 15:36:03 +0530
Message-ID: <20091218100603.GC9437@skywalker.linux.vnet.ibm.com>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
 <87bpi6zquv.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54421 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZLRKGI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 05:06:08 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id nBIL68BM015392
	for <linux-ext4@vger.kernel.org>; Sat, 19 Dec 2009 08:06:08 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nBIA67Zh1007662
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 21:06:07 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nBIA66Kw021742
	for <linux-ext4@vger.kernel.org>; Fri, 18 Dec 2009 21:06:07 +1100
Content-Disposition: inline
In-Reply-To: <87bpi6zquv.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2009 at 08:22:16PM +0300, Dmitry Monakhov wrote:
> 
> drop i_block_reservation_lock before vfs_dq_reserve_block().
> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> changes from previous version:
>  - simplify the patch according to Jan's comments
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 942e183..2327f7a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1851,6 +1851,7 @@ repeat:
> 
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
>  	/*
>  	 * Make quota reservation here to prevent quota overflow
> @@ -1858,12 +1859,10 @@ repeat:
>  	 * time.
>  	 */
>  	if (vfs_dq_reserve_block(inode, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return -EDQUOT;
>  	}
> 
>  	if (ext4_claim_free_blocks(sbi, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		vfs_dq_release_reservation_block(inode, total);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
> @@ -1871,10 +1870,11 @@ repeat:
>  		}
>  		return -ENOSPC;
>  	}
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
>  	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
> -
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
>  	return 0;       /* success */


NACK
I guess we would end up setting i_reserved_meta_blocks wrongly because
mdblocks could be based on the old value of i_reserved_meta_blocks
because we are dropping i_block_reservation_lock lock.

-aneesh
