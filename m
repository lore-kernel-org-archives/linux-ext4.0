From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: fix wrong size computation in
 ext4_mb_normalize_request()
Date: Fri, 11 Jul 2014 11:04:52 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407111104090.2165@localhost.localdomain>
References: <alpine.LFD.2.00.1407110906340.2165@localhost.localdomain> <1405067660-728-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbaGKJFA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2014 05:05:00 -0400
In-Reply-To: <1405067660-728-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 11 Jul 2014, Xiaoguang Wang wrote:

> Date: Fri, 11 Jul 2014 16:34:20 +0800
> From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, lczerner@redhat.com,
>     Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Subject: [PATCH v2] ext4: fix wrong size computation in
>     ext4_mb_normalize_request()
> 
> As the member fe_len defined in struct ext4_free_extent is expressed as
> number of clusters, the variable "size" computation is wrong, we need to
> first translate fe_len to block number, then to bytes.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/ext4/mballoc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 7f72f50..975a35e 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3076,7 +3076,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  		size = 8 * 1024 * 1024;
>  	} else {
>  		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
> -		size	  = ac->ac_o_ex.fe_len << bsbits;
> +		size	  = (loff_t)EXT4_C2B(EXT4_SB(ac->ac_sb),
> +				     ac->ac_o_ex.fe_len) << bsbits;

The indentation is wrong, otherwise it looks good.

Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>


>  	}
>  	size = size >> bsbits;
>  	start = start_off >> bsbits;
> 
