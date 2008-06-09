From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Update i_disksize correctly in ext4_get_block
Date: Mon, 9 Jun 2008 15:15:04 +0530
Message-ID: <20080609094504.GA9518@skywalker>
References: <1212998970-3618-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46036 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758251AbYFIJp3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jun 2008 05:45:29 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m599j6BM020554
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:15:06 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m599ioX9921636
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:14:50 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m599j5K4029191
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jun 2008 15:15:06 +0530
Content-Disposition: inline
In-Reply-To: <1212998970-3618-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 09, 2008 at 01:39:30PM +0530, Aneesh Kumar K.V wrote:
> With delayed allocation we delay the allocation of blocks
> and request for blocks in multiple chunks. We should not
> update i_disksize to inode.i_size unless we are allocating
> blocks corresponding to the end of file.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |   10 ++++++++--
>  fs/ext4/inode.c   |   10 ++++++++--
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index dae3b60..a6d7165 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2698,6 +2698,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	int err = 0, depth, ret;
>  	unsigned long allocated = 0;
>  	struct ext4_allocation_request ar;
> +	loff_t disksize;
> 
>  	__clear_bit(BH_New, &bh_result->b_state);
>  	ext_debug("blocks %u/%lu requested for inode %u\n",
> @@ -2885,8 +2886,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  		goto out2;
>  	}
> 
> -	if (extend_disksize && inode->i_size > EXT4_I(inode)->i_disksize)
> -		EXT4_I(inode)->i_disksize = inode->i_size;
> +	if (extend_disksize) {
> +		disksize = ((loff_t) newblock + ar.len) << inode->i_blkbits;


s/newblock/iblock

I will send a new patch.



-aneesh
