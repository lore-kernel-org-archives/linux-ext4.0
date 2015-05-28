From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Try to initialize all groups we can in case of
 failure on ppc64
Date: Thu, 28 May 2015 10:21:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1505281009410.3256@localhost.localdomain>
References: <1432722326-25574-1-git-send-email-lczerner@redhat.com> <5565E646.8010202@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbbE1IVw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 04:21:52 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 77F20B72A0
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 08:21:52 +0000 (UTC)
In-Reply-To: <5565E646.8010202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 27 May 2015, Eric Sandeen wrote:

> Date: Wed, 27 May 2015 10:44:06 -0500
> From: Eric Sandeen <sandeen@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: Try to initialize all groups we can in case of
>     failure on ppc64
> 
> On 5/27/15 5:25 AM, Lukas Czerner wrote:
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
> >  fs/ext4/mballoc.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 8d1e602..7e28007 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -882,10 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> >  
> >  	/* wait for I/O completion */
> >  	for (i = 0, group = first_group; i < groups_per_page; i++, group++) {
> > -		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i])) {
> > +		if (bh[i] && ext4_wait_block_bitmap(sb, group, bh[i]))
> >  			err = -EIO;
> > -			goto out;
> > -		}
> >  	}
> >  
> >  	first_block = page->index * blocks_per_page;
> > @@ -898,6 +896,13 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> >  			/* skip initialized uptodate buddy */
> >  			continue;
> >  
> > +		if (!buffer_verified(bh[group - first_group]) ||
> > +		    !buffer_uptodate(bh[group - first_group]))
> > +			/* Skip faulty bitmaps */
> > +			continue;
> > +		else
> > +			err = 0;
> > +
> 
> Hm, ext4_wait_block_bitmap() can fail 3 ways (buffer not update, or not verified,
> but also if ext4_get_group_desc fails), but this only checks 2 of those, right?

Yes, maybe it'll be worth it to return an error if
ext4_get_group_desc() fails as well. -EIO is not exactly what
happens there, but I guess it's the nest option anyway.

> 
> If ext4_get_group_desc fails, we'll have a bh which is new, may or may not be
> uptodate, and ... I guess it won't be verified in that case either, will it.  So
> that's probably ok.

We still need to get the error code from ext4_wait_block_bitmap()
though.

> 
> In fact, is the (!verified) test enough, here? (IOWs, could it possibly be verified,
> but not uptodate?) 

Yes, now when I come to think about this !verified should be enough
for, because it should not be verified if its not uptodate.

> 
> 
> In the bigger picture - if the filesystem is corrupt (or the device is bad) in this
> way, do we really *want* to continue?  What are the consequences of doing so,
> and have you tested with a filesystem partially-initialized like this?

First of all we already do this if the block bitmap is corrupt
(that's why we're verifying it) or checksum does not match (it's
corrupt). What we do there is just mark the bitmap corrupt so we do
not try that anymore.

But this is different, at least in my read example. Because if read
fails there is a slight chance that it'll succeed in the future
(link comes up again or whatever), so trying it again next time
seems ok to me. It should make file system more resilient that way.
However maybe I should make this on for errors=continue case.

And yes I tested it with fialty mdadm on ppc64.


> 
> Thinking more about it ... (sorry for the stream of consciousness here) - if validation
> fails, encountering this sort of error will trigger remount,ro or panic unless
> errors=continue, right?  But I guess that's still the default, so maybe we do expect
> to continue.  So I go back to the question of: have you tested with partial init
> like this, to be sure we don't fall off some cliff later?

Yes, errors=continue is the default so the default behaviour would
be an endless loop without this patch.

Note that there is another problem that it'll loop forever even on
x86_64 in the case that all the bitmaps are corrupt, or can not be
read. That's mostly because we do not return error codes from
ext4_mb_good_group(). I am already testing a fix for that and will
send it together with v2 of this one.

Thanks!
-Lukas

> 
> Thanks,
> -Eric
> 
