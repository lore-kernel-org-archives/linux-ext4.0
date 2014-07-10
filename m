From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix wrong size computation in
 ext4_mb_normalize_request()
Date: Thu, 10 Jul 2014 11:25:07 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407101110560.5461@localhost.localdomain>
References: <1404970836-21357-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, mlombard@redhat.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaGJJZQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jul 2014 05:25:16 -0400
In-Reply-To: <1404970836-21357-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 10 Jul 2014, Xiaoguang Wang wrote:

> Date: Thu, 10 Jul 2014 13:40:36 +0800
> From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, mlombard@redhat.com,
>     Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Subject: [PATCH] ext4: fix wrong size computation in
>     ext4_mb_normalize_request()
> 
> As the member fe_len defined in struct ext4_free_extent is expressed as
> number of clusters, the variable "size" computation is wrong, we need to
> first translate it to block number, then to bytes.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/ext4/mballoc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 7f72f50..9a543b5 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3076,7 +3076,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  		size = 8 * 1024 * 1024;
>  	} else {
>  		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
> -		size	  = ac->ac_o_ex.fe_len << bsbits;
> +		size	  = EXT4_C2B(EXT4_SB(ac->ac_sb),
> +				     ac->ac_o_ex.fe_len) << bsbits;

There is a patch out there up for more discussion which rewrites a
whole bunch of code in ext4_mb_normalize_request(). But more
importantly this fix, while correct is not going to change anything
since this condition will never be run.

Btw, I take back the correct part since it seems that there is a
a possibility of overflow. This should be better.

		size	  = (loff_t)EXT4_C2B(EXT4_SB(ac->ac_sb),
					     ac->ac_o_ex.fe_len) << bsbits;

Thanks!
-Lukas

>  	}
>  	size = size >> bsbits;
>  	start = start_off >> bsbits;
> 
