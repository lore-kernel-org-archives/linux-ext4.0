From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] filefrag: fix minor issues with 29758d2
Date: Thu, 29 May 2014 12:29:53 -0500
Message-ID: <53876E91.604@redhat.com>
References: <53876D7D.8050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbaE2RbG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 13:31:06 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4THUUVe028256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 13:30:30 -0400
In-Reply-To: <53876D7D.8050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/29/14, 12:25 PM, Eric Sandeen wrote:
> 29758d2 filefrag: exit with error code if an error is hit
> 
> introduced a couple errors; in one case it missed returning
> a value, and in the other used a test where it needed an
> assignment.
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

And as an aside, here and other places where we do:

if (syscall() < 0) {
	close (fd);
	rc = -errno;
	perror("syscall");
	return rc;
}

we actually run the risk of close failing, and getting errno/perror from THAT,
but *shrug* for now...

-Eric

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

