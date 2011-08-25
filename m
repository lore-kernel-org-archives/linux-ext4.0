From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Thu, 25 Aug 2011 16:33:21 +0200
Message-ID: <201108251633.21372.rjw@sisk.pl>
References: <201108112329.23043.rjw@sisk.pl> <201108240018.32189.rjw@sisk.pl> <20110825134956.GA10476@ucw.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:37593 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab1HYObc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Aug 2011 10:31:32 -0400
In-Reply-To: <20110825134956.GA10476@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday, August 25, 2011, Pavel Machek wrote:
> Hi!
> 
> > > > > The problem really isn't XFS specific, nor is it new - the fact is
> > > > > that any filesystem that has registered a shrinker or can do async
> > > > > work in the background post-sync is vulnerable to this problem. It's
> > > > 
> > > > Should we avoid calling shrinkers while hibernating?
> > > 
> > > If you like getting random OOM problems when hibernating, then go
> > > for it.  Besides, shrinkers are used for more than just filesystems,
> > > so you might find you screw entire classes of users by doing this
> > > (eg everyone using intel graphics and 3D).
> > > 
> > > > Or put BUG_ON()s into filesystem shrinkers so that this can not
> > > > happen?
> > > 
> > > Definitely not. If your concern is filesystem shrinkers and you want
> > > a large hammer to hit the problem with then do your hibernate
> > > image allocation wih GFP_NOFS and the filesystem shrinkers will
> > > abort without doing anything.
> > 
> > I think we can do that, actually.
> 
> I believe we should, yes. Question is if it helps much, because
> various drivers (and userspace in case uswsusp?) will still trigger
> GFP_KERNEL allocations.
> 
> Something like this?
> 
> --- snapshot.c.ofic	2011-08-25 15:48:41.000000000 +0200
> +++ snapshot.c	2011-08-25 15:49:07.000000000 +0200
> @@ -1107,7 +1107,7 @@
>  
>  /* Helper functions used for the shrinking of memory. */
>  
> -#define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN)
> +#define GFP_IMAGE	(GFP_NODS | __GFP_NOWARN)

Surely GFP_NOFS?

>  
>  /**
>   * preallocate_image_pages - Allocate a number of pages for hibernation image
> 
> 
> 

