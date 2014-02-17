From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] ext4: don't leave i_crtime.tv_sec uninitialized
Date: Mon, 17 Feb 2014 11:31:15 +0100
Message-ID: <5301E4F3.8050104@oracle.com>
References: <1392597082-7483-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20400 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaBQKbW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Feb 2014 05:31:22 -0500
In-Reply-To: <1392597082-7483-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/17/2014 01:31 AM, Theodore Ts'o wrote:
> If the i_crtime field is not present in the inode, don't leave the
> field uninitialized.
>
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>   fs/ext4/ext4.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ece5556..d3a534f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -771,6 +771,8 @@ do {									       \
>   	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
>   		(einode)->xtime.tv_sec = 				       \
>   			(signed)le32_to_cpu((raw_inode)->xtime);	       \
> +	else								       \
> +		(einode)->xtime.tv_sec = 0;				       \
>   	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
>   		ext4_decode_extra_time(&(einode)->xtime,		       \
>   				       raw_inode->xtime ## _extra);	       \
>

This fixes everything for me, thanks!


Vegard
