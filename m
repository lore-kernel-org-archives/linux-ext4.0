From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Don't dereference NULL upon slashless module dependency
 line.
Date: Thu, 26 Feb 2009 16:18:29 -0600
Message-ID: <49A71535.3010607@redhat.com>
References: <87fxi5dt0g.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZBZWSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Feb 2009 17:18:34 -0500
In-Reply-To: <87fxi5dt0g.fsf@meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jim Meyering wrote:
> * probe.c (check_for_modules): Skip current line if it has no slash.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
> I found this by inspection while looking for the cause of
> a recent rawhide/nash segfault.
> 
>  lib/blkid/probe.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
> index 76763ae..f5fff6b 100644
> --- a/lib/blkid/probe.c
> +++ b/lib/blkid/probe.c
> @@ -225,8 +225,9 @@ static int check_for_modules(const char *fs_name)
>  			*cp = 0;
>  		else
>  			continue;
> -		if ((cp = strrchr(buf, '/')) != NULL)
> -			cp++;
> +		if ((cp = strrchr(buf, '/')) == NULL)
> +			continue;
> +		cp++;
>  		i = strlen(cp);
>  		if (i > 3) {
>  			t = cp + i - 3;
> --

oops, I missed that Jim sent this (or just didn't remember w/ my
goldfish brain)

OTOH the other patch I sent is probably a bit better, it gets both
pieces of duplicated(!) code, and doeesn't skip these lines in
modules.dep, it just skips the pre-"/"-stripping ...

-Eric
