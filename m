From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] filefrag: count optimize non-verbose mode; count 0 extents
 properly when verbose
Date: Thu, 09 Dec 2010 11:19:04 -0600
Message-ID: <4D010F88.9030707@redhat.com>
References: <4CEC4C86.1030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0LIRTG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Dec 2010 12:19:06 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oB9HJ676014734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 9 Dec 2010 12:19:06 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oB9HJ5QE000381
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 9 Dec 2010 12:19:06 -0500
In-Reply-To: <4CEC4C86.1030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/10 5:21 PM, Eric Sandeen wrote:
> # rm -f a; touch a; filefrag -v a
> 
> yields 1 extent when it should be 0.  Without -v, 0 is returned.
> 
> Fix this up by special-casing no extents returned in verbose
> mode; skip printing the header for the columns too, since there
> are no columns to print.
> 
> Also, in nonverbose mode we can set fm_extent_count to 0
> so that FIEMAP will just query the extent count without gathering
> details; as it is today I think a non-verbose query may under-report
> the extent count once "count" extents have been filled in.
> 
> Addresses-redhat-bugzilla: 653234
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ted, wondering if you can push this one in as well, if it looks ok;
I'd like to get it upstream before adding it to our package for the
above bug.

Thanks,
-Eric

> ---
> 
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index bd4486d..a48b9b0 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -194,7 +194,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  	do {
>  		fiemap->fm_length = ~0ULL;
>  		fiemap->fm_flags = flags;
> -		fiemap->fm_extent_count = count;
> +		/*
> +		 * If fm_extent_count == 0, FIEMAP returns count of
> +		 * extents found without filling in details.
> +		 */
> +		if (!verbose)
> +			fiemap->fm_extent_count = 0;
> +		else
> +			fiemap->fm_extent_count = count;
>  		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
>  		if (rc < 0) {
>  			if (errno == EBADR && fiemap_incompat_printed == 0) {
> @@ -206,6 +213,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  		}
>  
>  		if (verbose && !fiemap_header_printed) {
> +			/*
> +			 * No extents on first call?
> +			 * Skip header and show 0 extents.
> +			 */
> +			if (fiemap->fm_mapped_extents == 0) {
> +				*num_extents = 0;
> +				goto out;
> +			}
>  			printf(" ext %*s %*s %*s length flags\n", logical_width,
>  			       "logical", physical_width, "physical",
>  			       physical_width, "expected");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

