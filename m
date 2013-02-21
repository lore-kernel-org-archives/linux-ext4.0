From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix flag settings in e2image.h
Date: Thu, 21 Feb 2013 14:00:53 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302211356490.19354@localhost>
References: <1361448418-26688-1-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3BUNA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2013 08:00:57 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1LD0uj5005171
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2013 08:00:56 -0500
In-Reply-To: <1361448418-26688-1-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Feb 2013, Tomas Racek wrote:

> Date: Thu, 21 Feb 2013 13:06:58 +0100
> From: Tomas Racek <tracek@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: Tomas Racek <tracek@redhat.com>
> Subject: [PATCH] e2fsprogs: fix flag settings in e2image.h
> 
> This prevents from SIGSEGV when -s options is used.

oops! Thanks for catching that. I just wonder why the regression
test is not catching that ?


you can add

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  lib/ext2fs/e2image.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/ext2fs/e2image.h b/lib/ext2fs/e2image.h
> index c918529..5537980 100644
> --- a/lib/ext2fs/e2image.h
> +++ b/lib/ext2fs/e2image.h
> @@ -19,7 +19,7 @@
>  /* Image flags */
>  #define E2IMAGE_INSTALL_FLAG	1
>  #define E2IMAGE_SCRAMBLE_FLAG	2
> -#define E2IMAGE_IS_QCOW2_FLAG	3
> +#define E2IMAGE_IS_QCOW2_FLAG	4
>  
>  struct ext2_image_hdr {
>  	__u32	magic_number;	/* This must be EXT2_ET_MAGIC_E2IMAGE */
> 
