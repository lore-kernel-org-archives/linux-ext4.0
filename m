Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:58646 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbeJ3WjX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 30 Oct 2018 18:39:23 -0400
Subject: Re: [PATCH 3/7] ext4 resize: missing brelse() in case success in
 add_new_gdb()
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
References: <d8c84f46-7ffe-7fd3-0e70-775c3c59320e@virtuozzo.com>
From: Vasily Averin <vvs@virtuozzo.com>
Message-ID: <3a7944cb-ca99-49d1-85e8-f5371a86fba6@virtuozzo.com>
Date: Tue, 30 Oct 2018 16:45:45 +0300
MIME-Version: 1.0
In-Reply-To: <d8c84f46-7ffe-7fd3-0e70-775c3c59320e@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

please drop this one, it isn't correct.

On 10/29/2018 06:25 PM, Vasily Averin wrote:
> Fixes ac27a0ec112a ("ext4: initial copy of files from ext3")
> #? cc: stable <stable@vger.kernel.org>     # 2.6.19 or evel earlier in ext3
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>  fs/ext4/resize.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 0a4dc6217e78..ff17480e8613 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -874,6 +874,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
>  		goto exit_inode;
>  	}
>  	brelse(dind);
> +	brelse(iloc.bh);
>  
>  	o_group_desc = EXT4_SB(sb)->s_group_desc;
>  	memcpy(n_group_desc, o_group_desc,
> 
