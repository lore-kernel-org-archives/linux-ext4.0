From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 4/6] [64-bit] enable dumpe2fs 64-bitness and fix printf formats.
Date: Mon, 4 May 2009 02:21:14 -0400
Message-ID: <20090504062114.GF9151@shell>
References: <15579.1241167627@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZEDGVP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 02:21:15 -0400
Content-Disposition: inline
In-Reply-To: <15579.1241167627@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:47:07AM -0400, Nick Dokos wrote:
> Add  EXT2_FLAG_NEW_BITMAPS to the ext2fs_open() flags.
> 
> Change signature of print_range(): both arguments of the range
> are now unsigned long long, with the concomitant change to the
> printf formats.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  misc/dumpe2fs.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 8a746ee..4d5c90e 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -63,12 +63,12 @@ static void print_number(unsigned long num)
>  		printf("%lu", num);
>  }
>  
> -static void print_range(unsigned long a, unsigned long b)
> +static void print_range(unsigned long long a, unsigned long long b)
>  {
>  	if (hex_format)
> -		printf("0x%04lx-0x%04lx", a, b);
> +		printf("0x%llx-0x%llx", a, b);
>  	else
> -		printf("%lu-%lu", a, b);
> +		printf("%llu-%llu", a, b);
>  }
>  
>  static void print_free (unsigned long group, char * bitmap,
> @@ -481,7 +481,7 @@ int main (int argc, char ** argv)
>  	if (optind > argc - 1)
>  		usage();
>  	device_name = argv[optind++];
> -	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES;
> +	flags = EXT2_FLAG_JOURNAL_DEV_OK | EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_NEW_BITMAPS;
>  	if (force)
>  		flags |= EXT2_FLAG_FORCE;
>  	if (image_dump)
> -- 
> 1.6.0.6
> 

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

-VAL
