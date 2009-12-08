From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 1/4] ext4: ext4_get_reserved_space() must return bytes
 instead of blocks
Date: Mon, 07 Dec 2009 17:04:41 -0800
Message-ID: <1260234281.4206.152.camel@mingming-laptop>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46457 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935732AbZLHBEl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 20:04:41 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id nB811thA003542
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 18:01:55 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB814hEV163266
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 18:04:43 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB814h8k029664
	for <linux-ext4@vger.kernel.org>; Mon, 7 Dec 2009 18:04:43 -0700
In-Reply-To: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-11-25 at 09:57 +0300, Dmitry Monakhov wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ab22297..cc4737e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1057,7 +1057,7 @@ qsize_t ext4_get_reserved_space(struct inode *inode)
>  		EXT4_I(inode)->i_reserved_meta_blocks;
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> 
> -	return total;
> +	return (total << inode->i_blkbits);
>  }
>  /*
>   * Calculate the number of metadata blocks need to reserve
It's a pity that we missed this fix at the time the change set merge to
the upstream, thanks for catching this.

Acked-by: Mingming Cao <cmm@us.ibm.com>

Mingming

