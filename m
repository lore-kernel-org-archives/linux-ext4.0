From: frankcmoeller@arcor.de
Subject: Aw: Re: Ext4: Slow performance on first write after mount
Date: Tue, 21 May 2013 20:02:36 +0200 (CEST)
Message-ID: <46558986.3488364.1369159356954.JavaMail.ngmail@webmail09.arcor-online.net>
References: <D1047C91-765D-4EBD-A6CC-869DF0D5AD90@dilger.ca> <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net> <20130519140023.GB7183@thunk.org> <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca> <20130520114647.GC8404@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:58766 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000Ab3EUSCi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 May 2013 14:02:38 -0400
In-Reply-To: <D1047C91-765D-4EBD-A6CC-869DF0D5AD90@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

only a short question: 

> I like the idea of keeping the high bits of the buddy bitmap in the group
> descriptor, instead of just the largest free order. It takes the same
> amount of space, but provides more information. 
More informations for what? The allocator or better the good_group function
needs bb_largest_free_order and in some cases fragment count. Do you 
want to use the bitmap for a not 100% correct fragment count calculation? 
Or is there another use for it?

Best regards,
Frank

> 
> > On Sun, 19 May 2013 21:36:02 +0200 (CEST) Frank C Moeller wrote:
> >> From my point (end user) I would prefer a builtin solution. I'm also a
> >> programmer and I can therefore understand why you don't want to change
> >> anything.
> > 
> > It's not that I don't want to change anything, it's that I'm very
> > hesitant to add new mount options or new code paths that now need more
> > testing unless there's no other way of addressing a particular use
> > case.  Another consideration is how to do it in such a way that it
> > doesn't degrade other users' performance.
> > 
> > Issuing readahead requests for the bitmap blocks might be good
> > compromise; since they are readahead requests, as low priority
> > requests they won't interfere with anything else going on, and in
> > practice, unless you are starting your video recording **immediately**
> > after the reboot, it should address your concern.
> 
> Right. Some of our users do something similar in userspace to avoid
> slowdown on first write, which doesn't _usually_ happen immediately
> after mount, but this isn't always helpful. 
> 
> >  (Also note that for
> > most people willing to hack a DVR, adding a line to /etc/rc.local is
> > usually considered easier than building a new kernel from sources and
> > then after making file system format changes, requiring a reformat of
> > their data disk!)
> 
> I think storing the buddy bitmap top bits in the GDT could be a COMPAT
> feature.  It is just a hint that could be ignored or incorrect, since
> the actual bitmap would be authoritative. 
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
