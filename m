From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/3] ext4 block reservation fix3
Date: Mon, 25 Jun 2007 15:35:33 +0400
Message-ID: <467FA885.3040309@clusterfs.com>
References: <20070622121509.GA395@localhost.sw.ru> <20070622121710.GB395@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, devel@openvz.org
To: Dmitry Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:61079 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbXFYLfw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2007 07:35:52 -0400
In-Reply-To: <20070622121710.GB395@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Acked-off-by: Alex Tomas <alex@clusterfs.com>

thanks, Alex

Dmitry Monakhov wrote:
> If ext4_reserve_block has failed we have to drop quota.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index a9655f1..eacffd3 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1467,7 +1467,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
>  	if (!(EXT4_I(inode)->i_state & EXT4_STATE_BLOCKS_RESERVED)) {
>  		*errp = ext4_reserve_blocks(sb, num);
>  		if (*errp)
> -			return 0;
> +			goto out;
>  		reserved = num;
>  	}
>  
