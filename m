From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] ext4: Try to initialize all groups we can in case
 of failure on ppc64
Date: Tue, 2 Jun 2015 09:53:27 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506020953100.4950@localhost.localdomain>
References: <1433145301-14605-1-git-send-email-lczerner@redhat.com> <1433145301-14605-2-git-send-email-lczerner@redhat.com> <A65D0935-3D92-4C0A-979A-7AAD8C7A39FA@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbbFBHxd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2015 03:53:33 -0400
In-Reply-To: <A65D0935-3D92-4C0A-979A-7AAD8C7A39FA@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 1 Jun 2015, Andreas Dilger wrote:

> Date: Mon, 1 Jun 2015 13:15:35 -0600
> From: Andreas Dilger <adilger@dilger.ca>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 2/3] ext4: Try to initialize all groups we can in case of
>     failure on ppc64
> 
> 
> > On Jun 1, 2015, at 1:55 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > 
> > Currently on the machines with page size > block size when initializing
> > block group buddy cache we initialize it for all the block group bitmaps
> > in the page. However in the case of read error, checksum error, or if
> > a single bitmap is in any way corrupted we would fail to initialize all
> > of the bitmaps. This is problematic because we will not have access to
> > the other allocation groups even though those might be perfectly fine
> > and usable.
> > 
> > Fix this by reading all the bitmaps instead of error out on the first
> > problem and simply skip the bitmaps which were either not read properly,
> > or are not valid.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > fs/ext4/mballoc.c | 10 +++++++---
> > 1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 8d1e602..5677a03 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -882,10 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> > 
> > 	/* wait for I/O completion */
> > 	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> > -		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
> > +		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
> > 			err = -EIO;
> > -			goto out;
> > -		}
> > 	}
> > 
> > 	first_block = page->index * blocks_per_page;
> > @@ -898,6 +896,12 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> > 			/* skip initialized uptodate buddy */
> > 			continue;
> > 
> > +		if (!buffer_verified(bh[group - first_group]))
> > +			/* Skip faulty bitmaps */
> > +			continue;
> > +		else
> > +			err = 0;
> 
> Not really a need for "else" here after the "continue" line, but that
> is mostly harmless.
> 
> Cheers, Andreas

Good point, I can fix that.

Thanks!
-Lukas
