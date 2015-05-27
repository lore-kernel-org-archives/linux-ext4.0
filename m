From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Try to initialize all groups we can in case of
 failure on ppc64
Date: Wed, 27 May 2015 10:44:06 -0500
Message-ID: <5565E646.8010202@redhat.com>
References: <1432722326-25574-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbbE0PoH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2015 11:44:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4RFi7oO025572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Wed, 27 May 2015 11:44:07 -0400
In-Reply-To: <1432722326-25574-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/27/15 5:25 AM, Lukas Czerner wrote:
> Currently on the machines with page size > block size when initializing
> block group buddy cache we initialize it for all the block group bitmaps
> in the page. However in the case of read error, checksum error, or if
> a single bitmap is in any way corrupted we would fail to initialize all
> of the bitmaps. This is problematic because we will not have access to
> the other allocation groups even though those might be perfectly fine
> and usable.
> 
> Fix this by reading all the bitmaps instead of error out on the first
> problem and simply skip the bitmaps which were either not read properly,
> or are not valid.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/mballoc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8d1e602..7e28007 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -882,10 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
>  
>  	/* wait for I/O completion */
>  	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> -		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
> +		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
>  			err = -EIO;
> -			goto out;
> -		}
>  	}
>  
>  	first_block = page->index * blocks_per_page;
> @@ -898,6 +896,13 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
>  			/* skip initialized uptodate buddy */
>  			continue;
>  
> +		if (!buffer_verified(bh[group - first_group]) ||
> +		    !buffer_uptodate(bh[group - first_group]))
> +			/* Skip faulty bitmaps */
> +			continue;
> +		else
> +			err = 0;
> +

Hm, ext4_wait_block_bitmap() can fail 3 ways (buffer not update, or not verified,
but also if ext4_get_group_desc fails), but this only checks 2 of those, right?

If ext4_get_group_desc fails, we'll have a bh which is new, may or may not be
uptodate, and ... I guess it won't be verified in that case either, will it.  So
that's probably ok.

In fact, is the (!verified) test enough, here? (IOWs, could it possibly be verified,
but not uptodate?) 


In the bigger picture - if the filesystem is corrupt (or the device is bad) in this
way, do we really *want* to continue?  What are the consequences of doing so,
and have you tested with a filesystem partially-initialized like this?

Thinking more about it ... (sorry for the stream of consciousness here) - if validation
fails, encountering this sort of error will trigger remount,ro or panic unless
errors=continue, right?  But I guess that's still the default, so maybe we do expect
to continue.  So I go back to the question of: have you tested with partial init
like this, to be sure we don't fall off some cliff later?

Thanks,
-Eric
