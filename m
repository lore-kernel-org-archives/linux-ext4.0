From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: don't accept too-high revision levels
Date: Thu, 14 Jan 2016 12:35:37 -0600
Message-ID: <5697EA79.40902@redhat.com>
References: <5362A6A2.7040504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbcANSfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jan 2016 13:35:39 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 42577C0BF2D0
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 18:35:39 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u0EIZb6m032006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 13:35:39 -0500
In-Reply-To: <5362A6A2.7040504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Came across this, still not merged, so ping?

On 5/1/14 2:55 PM, Eric Sandeen wrote:
> It's a bit strange to accept revision levels higher than
> the code creating the filesystem can understand, so don't
> allow it.
> 
> At least the kernel will mount the fs readonly if it's too
> high, but no other utility will touch it, so you can't
> fix the error.
> 
> Just reject anything > EXT2_MAX_SUPP_REV at mkfs time.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index aecd5d5..82019dc 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1679,9 +1679,10 @@ profile_error:
>  			break;
>  		case 'r':
>  			r_opt = strtoul(optarg, &tmp, 0);
> -			if (*tmp) {
> +			if (*tmp || (r_opt > EXT2_MAX_SUPP_REV)) {
>  				com_err(program_name, 0,
> -					_("bad revision level - %s"), optarg);
> +					_("bad revision level - %s (max %d)"),
> +					   optarg, EXT2_MAX_SUPP_REV);
>  				exit(1);
>  			}
>  			fs_param.s_rev_level = r_opt;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

