From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] fs / ext3: Always unlock updates in ext3_freeze()
Date: Thu, 25 Aug 2011 15:49:56 +0200
Message-ID: <20110825134956.GA10476@ucw.cz>
References: <201108112329.23043.rjw@sisk.pl>
 <20110822130045.GC11264@atrey.karlin.mff.cuni.cz>
 <20110822231348.GS3162@dastard>
 <201108240018.32189.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201108240018.32189.rjw@sisk.pl>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> > > > The problem really isn't XFS specific, nor is it new - the fact is
> > > > that any filesystem that has registered a shrinker or can do async
> > > > work in the background post-sync is vulnerable to this problem. It's
> > > 
> > > Should we avoid calling shrinkers while hibernating?
> > 
> > If you like getting random OOM problems when hibernating, then go
> > for it.  Besides, shrinkers are used for more than just filesystems,
> > so you might find you screw entire classes of users by doing this
> > (eg everyone using intel graphics and 3D).
> > 
> > > Or put BUG_ON()s into filesystem shrinkers so that this can not
> > > happen?
> > 
> > Definitely not. If your concern is filesystem shrinkers and you want
> > a large hammer to hit the problem with then do your hibernate
> > image allocation wih GFP_NOFS and the filesystem shrinkers will
> > abort without doing anything.
> 
> I think we can do that, actually.

I believe we should, yes. Question is if it helps much, because
various drivers (and userspace in case uswsusp?) will still trigger
GFP_KERNEL allocations.

Something like this?

--- snapshot.c.ofic	2011-08-25 15:48:41.000000000 +0200
+++ snapshot.c	2011-08-25 15:49:07.000000000 +0200
@@ -1107,7 +1107,7 @@
 
 /* Helper functions used for the shrinking of memory. */
 
-#define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN)
+#define GFP_IMAGE	(GFP_NODS | __GFP_NOWARN)
 
 /**
  * preallocate_image_pages - Allocate a number of pages for hibernation image


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
