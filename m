From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext2: Make sb magic number endianness conversion
 consistent
Date: Thu, 17 Oct 2013 19:50:59 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310171948320.3212@localhost.localdomain>
References: <1382030698-8746-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216Ab3JQRvC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Oct 2013 13:51:02 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9HHp2w3016883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Oct 2013 13:51:02 -0400
In-Reply-To: <1382030698-8746-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Oct 2013, Carlos Maiolino wrote:

> Date: Thu, 17 Oct 2013 14:24:58 -0300
> From: Carlos Maiolino <cmaiolino@redhat.com>
> To: linux-ext4@vger.kernel.org
> Subject: [PATCH] ext2: Make sb magic number endianness conversion consistent
> 
> All ext2_super_block fields are converted from le16 to cpu when checked or
> loaded into memory. Magic number check is the only field where we convert the
> magic number to le16. So, make the conversion pattern consistent with the
> remaining code

This not exactly true since this kind of comparison when a constant
is converted rather the variable is present on several places in
ext2, ext3 and ext4 (ext3 and ext4 have the same check you're fixing
here as well). I personally do not see the problem with this,
so honestly I do not see a reason to fix this.

Thanks!
-Lukas

> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/ext2/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 2885349..808f99f 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -927,7 +927,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		}
>  		es = (struct ext2_super_block *) (((char *)bh->b_data) + offset);
>  		sbi->s_es = es;
> -		if (es->s_magic != cpu_to_le16(EXT2_SUPER_MAGIC)) {
> +		if (le16_to_cpu(es->s_magic) != EXT2_SUPER_MAGIC) {
>  			ext2_msg(sb, KERN_ERR, "error: magic mismatch");
>  			goto failed_mount;
>  		}
> 
