From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix quota accounting in case of fallocate
Date: Tue, 30 Mar 2010 23:38:48 +0530
Message-ID: <87zl1py95b.fsf@linux.vnet.ibm.com>
References: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36340 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0C3SIz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Mar 2010 14:08:55 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp09.au.ibm.com (8.14.3/8.13.1) with ESMTP id o2UI8s1H004672
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:08:54 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2UI2fui1478862
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:02:41 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2UI8rCZ009966
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 05:08:54 +1100
In-Reply-To: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 30 Mar 2010 18:24:35 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> allocated_meta_data is already included in 'used' variable.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bec222c..bf989fb 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1110,7 +1110,8 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  		 */
>  		if (allocated_meta_blocks)
>  			dquot_claim_block(inode, allocated_meta_blocks);
> -		dquot_release_reservation_block(inode, mdb_free + used);
> +		dquot_release_reservation_block(inode, mdb_free + used -
> +			allocated_meta_blocks);
>  	}
> 
>  	/*

Do we really need to do this ? IIUC reservation count and actual
allocated count are two different. One block allocation we need to
remove all the blocks reserved from the reservation count and add
actually allocated blocks to the allocated count.

-aneesh
