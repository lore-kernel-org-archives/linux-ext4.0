From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/4] ext4: ext4_get_reserved_space() must return bytes
 instead of blocks
Date: Wed, 25 Nov 2009 10:32:46 -0600
Message-ID: <4B0D5C2E.7000007@redhat.com>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Mingming <cmm@us.ibm.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbZKYQcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 11:32:46 -0500
In-Reply-To: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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

