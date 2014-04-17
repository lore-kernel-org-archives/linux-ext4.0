From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fallocate_zero_range, check if is regular file
Date: Thu, 17 Apr 2014 13:08:49 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404171307520.2143@localhost.localdomain>
References: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaDQLIx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 07:08:53 -0400
In-Reply-To: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Apr 2014, jon ernst wrote:

> Date: Thu, 17 Apr 2014 00:22:04 -0400
> From: jon ernst <jonernst07@gmail.com>
> To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
> Subject: [PATCH] ext4: fallocate_zero_range, check if is regular file
> 
> fallocate_zero_range, check if inode is regular file.
> 
> Signed-off-by: Jon Ernst <jonernst07@gmail.com>

Thanks, you can add.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> ---
>  fs/ext4/extents.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1bb3e4b..756a3b9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4742,6 +4742,8 @@ static long ext4_zero_range(struct file *file,
> loff_t offset,
> 
>     trace_ext4_zero_range(inode, offset, len, mode);
> 
> +   if (!S_ISREG(inode->i_mode))
> +       return -EOPNOTSUPP;
>     /*
>      * Write out all dirty pages to avoid race conditions
>      * Then release them.
