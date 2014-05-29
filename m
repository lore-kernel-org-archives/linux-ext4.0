From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] filefrag: fix minor issues with 29758d2
Date: Thu, 29 May 2014 19:34:22 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405291932200.2106@localhost.localdomain>
References: <53876D7D.8050108@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbaE2Rfh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 13:35:37 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4THZ1Di029624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 13:35:01 -0400
In-Reply-To: <53876D7D.8050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 29 May 2014, Eric Sandeen wrote:

> Date: Thu, 29 May 2014 12:25:17 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: ext4 development <linux-ext4@vger.kernel.org>
> Cc: Andreas Dilger <adilger@dilger.ca>
> Subject: [PATCH] filefrag: fix minor issues with 29758d2
> 
> 29758d2 filefrag: exit with error code if an error is hit
> 
> introduced a couple errors; in one case it missed returning
> a value, and in the other used a test where it needed an
> assignment.

Looks good, although I wonder if we can just return -errno or goto
out_close ? (same with fstat failure).

Thanks!
-Lukas

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 37c4416..b2826ad 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -387,8 +387,9 @@ static int frag_report(const char *filename)
>  	if (last_device != st.st_dev) {
>  		if (fstatfs(fd, &fsinfo) < 0) {
>  			close(fd);
> +			rc = -errno;
>  			perror("fstatfs");
> -			return;
> +			return rc;
>  		}
>  		if (verbose)
>  			printf("Filesystem type is: %lx\n",
> @@ -556,7 +557,7 @@ int main(int argc, char**argv)
>  		int rc2 = frag_report(*cpp);
>  
>  		if (rc2 < 0 && rc == 0)
> -			rc == rc2;
> +			rc = rc2;
>  	}
>  
>  	return rc;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
