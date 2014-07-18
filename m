From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: free bh on csum verify error in do_one_pass
Date: Fri, 18 Jul 2014 11:04:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407181104330.12453@localhost.localdomain>
References: <53C83C1F.8020303@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760770AbaGRJEs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2014 05:04:48 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6I94mDO032761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2014 05:04:48 -0400
In-Reply-To: <53C83C1F.8020303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Jul 2014, Eric Sandeen wrote:

> Date: Thu, 17 Jul 2014 16:11:59 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: ext4 development <linux-ext4@vger.kernel.org>
> Subject: [PATCH] e2fsck: free bh on csum verify error in do_one_pass
> 
> Coverity (re-)spotted this; it was triaged as a false positive,
> but it seems pretty clear that the bh (which was just checked)
> isn't currently freed before the function exits.

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas


> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
> index 54579c2..66d02b2 100644
> --- a/e2fsck/recovery.c
> +++ b/e2fsck/recovery.c
> @@ -523,6 +523,7 @@ static int do_one_pass(journal_t *journal,
>  			    !jbd2_descr_block_csum_verify(journal,
>  							  bh->b_data)) {
>  				err = -EIO;
> +				brelse(bh);
>  				goto failed;
>  			}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
