From: frankcmoeller@arcor.de
Subject: Aw: Re: Ext4: Slow performance on first write after mount
Date: Mon, 20 May 2013 22:54:22 +0200 (CEST)
Message-ID: <1300929255.1641638.1369083262407.JavaMail.ngmail@webmail15.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:35291 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561Ab3ETUyY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 16:54:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi together,

> > and then in the
> > kernel, we could have a loop which checks to see if the bitmap blocks
> > were already in cache, and if they were, to initialize the buddy
> > bitmaps pages.  That way, even if subsequent memory pressure were to
> > push the buddy bitmap pages and allocation bitmaps out of the cache,
> > it would mean that all of the ext4_group_info structures would be
> > initialized, and just having the bb_largest_free_order information
> > will very much help things.
> 
> I like the idea of keeping the high bits of the buddy bitmap in the group
> descriptor, instead of just the largest free order. It takes the same
> amount of space, but provides more information. 

If you use the reserved field for this, users don't need to reformat their disks
and "only" need to use a new kernel, right? That sounds really good to me.

> > Issuing readahead requests for the bitmap blocks might be good
> > compromise; since they are readahead requests, as low priority
> > requests they won't interfere with anything else going on, and in
> > practice, unless you are starting your video recording **immediately**
> > after the reboot, it should address your concern.

If there is a normal recording the PVR starts some minutes (I think 2-3) 
before the recording starts. If an user starts the PVR, timeshift (it's a 
recording) might start around 30-40 seconds after mounting the disk. 
But if it's problematic I can let it start later. 
 
> >  (Also note that for
> > most people willing to hack a DVR, adding a line to /etc/rc.local is
> > usually considered easier than building a new kernel from sources and
> > then after making file system format changes, requiring a reformat of
> > their data disk!)
> 
> I think storing the buddy bitmap top bits in the GDT could be a COMPAT
> feature.  It is just a hint that could be ignored or incorrect, since
> the actual bitmap would be authoritative. 

Yes, adding a line to rc.local is easy. Building a new kernel is also no problem,
if the patch is compatible with the current used kernel versions (3.8.7 and also 
good would be 3.3.8 ). The PVR uses a good software management system 
(something like apt) and the users can update their software including kernel
every day.
Reformating is a problem, but if it's not preventable, users can choose between
workaround and reformat.

Best regards,
Frank

> 
> Cheers, Andreas
> 
> > So it's not that I'm against solutions that involve kernel changes or
> > file system format changes.  It's just that I want to make sure we
> > explore the entire solution space, since there are costs in terms of
> > testing costs, the need to do a backup-reformat-restore pass, etc,
> > etc., to some of the solutions that have been suggested so far.
> > 
> > Regards,
> > 
> >                        - Ted
> 
