From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] ext4: Try to initialize all groups we can in case of failure on ppc64
Date: Mon, 1 Jun 2015 13:15:35 -0600
Message-ID: <A65D0935-3D92-4C0A-979A-7AAD8C7A39FA@dilger.ca>
References: <1433145301-14605-1-git-send-email-lczerner@redhat.com> <1433145301-14605-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36546 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbFATPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jun 2015 15:15:43 -0400
Received: by pdjm12 with SMTP id m12so31559257pdj.3
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 12:15:43 -0700 (PDT)
In-Reply-To: <1433145301-14605-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Jun 1, 2015, at 1:55 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> 
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
> fs/ext4/mballoc.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 8d1e602..5677a03 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -882,10 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> 
> 	/* wait for I/O completion */
> 	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> -		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
> +		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
> 			err = -EIO;
> -			goto out;
> -		}
> 	}
> 
> 	first_block = page->index * blocks_per_page;
> @@ -898,6 +896,12 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> 			/* skip initialized uptodate buddy */
> 			continue;
> 
> +		if (!buffer_verified(bh[group - first_group]))
> +			/* Skip faulty bitmaps */
> +			continue;
> +		else
> +			err = 0;

Not really a need for "else" here after the "continue" line, but that
is mostly harmless.

Cheers, Andreas





