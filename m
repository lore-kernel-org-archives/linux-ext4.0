From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Sat, 16 Aug 2008 16:13:04 +0530
Message-ID: <20080816104304.GF6423@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815175243.GD6511@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:44018 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbYHPKnQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 06:43:16 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7GAhDlM032204
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 16:13:13 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7GAhD6J1687688
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 16:13:13 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7GAhCPM000819
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 16:13:13 +0530
Content-Disposition: inline
In-Reply-To: <20080815175243.GD6511@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 11:22:43PM +0530, Aneesh Kumar K.V wrote:
> commit 6ad9d25595aea8efa0d45c0a2dd28b4a415e34e6
> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Date:   Fri Aug 15 23:19:15 2008 +0530
> 
>     move the dirty inodes to the end of the list
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 1afcb11..650b021 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4258,7 +4258,8 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
> 
>  static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
>  {
> -	int order, added = 0, lg_prealloc_count = 1;
> +	int order, lg_prealloc_count = 1;
> +	bool added = 0;
>  	struct super_block *sb = ac->ac_sb;
>  	struct ext4_locality_group *lg = ac->ac_lg;
>  	struct ext4_prealloc_space *tmp_pa, *pa = ac->ac_pa;
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 25adfc3..95eee62 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -163,7 +163,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 */
>  		if (!was_dirty) {
>  			inode->dirtied_when = jiffies;
> -			list_move(&inode->i_list, &sb->s_dirty);
> +			list_move_tail(&inode->i_list, &sb->s_dirty);
>  		}
>  	}
>  out:
> @@ -208,7 +208,7 @@ static void redirty_tail(struct inode *inode)
>   */
>  static void requeue_io(struct inode *inode)
>  {
> -	list_move(&inode->i_list, &inode->i_sb->s_more_io);
> +	list_move_tail(&inode->i_list, &inode->i_sb->s_more_io);
>  }
> 
>  static void inode_sync_complete(struct inode *inode)

The patch is not really useful and is also wrong. Verifying the results
again I found that patch didn't make any difference.  We actually read
from the s_io list from the tail not from the head (generic_sync_sb_inodes)
That means inodes are already added in the order they are dirtied.

-aneesh
