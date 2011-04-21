From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: protect bb_first_free in ext4_trim_all_free() with
 group lock
Date: Thu, 21 Apr 2011 13:10:31 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1104211304480.14126@dhcp-27-109.brq.redhat.com>
References: <alpine.LFD.2.00.1104211135540.4399@dhcp-27-109.brq.redhat.com> <1303381596-13758-1-git-send-email-lczerner@redhat.com> <20110421110120.GB11901@bitwizard.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab1DULKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Apr 2011 07:10:36 -0400
In-Reply-To: <20110421110120.GB11901@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 21 Apr 2011, Rogier Wolff wrote:

> 
> Hi Lukas, 

Hi Rogier,

> 
> IMHO, I think it was written intentionally like that. You do as much
> as you can outside "having the lock", especially these "search" things
> are written this way. Doing it this way means that there is less
> lock-contention when things get busy.
> 
> Now I agree that this one statement without any function calls is
> going to be reasonably fast on any modern hardware...
> 
> 	Roger. 
> 
> 
>  	bitmap = e4b.bd_bitmap;
> +
> +	/* we take the lock AFTER this statement because if it
> +	   gets modified under us we'll correct later. */ 

The comment is not right. We do not correct it later in the case that
some space was freed and we still have the old value, hence skipping the
difference between the old and the new bb_first_free. As I mentioned in
the description this is not a big deal, but the fix is simple enough and
there is absolutely no "slowdown" in moving one simple condition into
critical section.

Thanks!
-Lukas

>  	start = (e4b.bd_info->bb_first_free > start) ?
>  		e4b.bd_info->bb_first_free : start;
> 	ext4_lock_group(sb, group);
>  
>  	while (start < max) {
>  		start = mb_find_next_zero_bit(bitmap, max, start);
> 
> 
> On Thu, Apr 21, 2011 at 12:26:36PM +0200, Lukas Czerner wrote:
> > We should protect reading bd_info->bb_first_free with the group lock
> > because otherwise we might miss some free blocks. This is not a big deal
> > at all, but the change to do right thing is really simple, so lets do
> > that.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/mballoc.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 776d7a8..804232a 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -4775,11 +4775,11 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
> >  				"information for %u", group);
> >  		return ret;
> >  	}
> > -
> >  	bitmap = e4b.bd_bitmap;
> > +
> > +	ext4_lock_group(sb, group);
> >  	start = (e4b.bd_info->bb_first_free > start) ?
> >  		e4b.bd_info->bb_first_free : start;
> > -	ext4_lock_group(sb, group);
> >  
> >  	while (start < max) {
> >  		start = mb_find_next_zero_bit(bitmap, max, start);
> > -- 
> > 1.7.4.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
