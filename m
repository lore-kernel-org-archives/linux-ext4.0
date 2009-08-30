From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] document flash/RAID dangers
Date: Sun, 30 Aug 2009 08:49:09 +0200
Message-ID: <20090830064909.GB1417__8908.16770629517$1251614986$gmane$org@ucw.cz>
References: <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com> <20090826004430.GR4300@elf.ucw.cz> <alpine.DEB.2.00.0908251817390.30426@asgard.lang.hm> <20090826112535.GF26595@elf.ucw.cz> <20090826123709.GJ32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, david@lang.hm,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.ne
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZH3GtQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 02:49:16 -0400
Content-Disposition: inline
In-Reply-To: <20090826123709.GJ32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2009-08-26 08:37:09, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 01:25:36PM +0200, Pavel Machek wrote:
> > > you just plain cannot count on writes that are in flight when a powerfail 
> > > happens to do predictable things, let alone what you consider sane or  
> > > proper.
> > 
> > From what I see, this kind of failure is rather harder to reproduce
> > than the software problems. And at least SGI machines were designed to
> > avoid this...
> > 
> > Anyway, I'd like to hear from ext3 people... what happens on read
> > errors in journal? That's what you'd expect to see in situation above.
> 
> On a power failure, what normally happens is that the random garbage
> gets written into the disk drive's last dying gasp, since the memory
> starts going insane and sends garbage to the disk.  So the disk
> successfully completes the write, but the sector contains garbage.
> Since HDD's tend to be last thing to die, being less sensitive to
> voltage drops than the memory or DMA controller, my experience is that
> you don't get a read error after the system comes up, you just get
> garbage written into the journal.
> 
> The ext3 journalling code waits until all of the journal code is
> written, and only then writes the commit block.  On restart, we look
> for the last valid commit block.  So if the power failure is before we
> write the commit block, we replay the journal up until the previous
> commit block.  If the power failure is while we are writing the commit
> block, garbage will be written out instead of the commit block, and so
> it falls back to the previous case.
> 
> We do not allow any updates to the filesystem metadata to take place
> until the commit block has been written; therefore the filesystem
> stays consistent.

Ok, cool.

> If there the journal *does* develop read errors, then fsck will
> require a manual fsck, and so the boot operation will get stopped so a
> system administrator can provide manual intervention.  The best bet
> for the sysadmin is to replay as much of the journal she can, and then
> let fsck fix any resulting filesystem inconsistencies.  In practice,

...and that should result in consistent fs with no data loss, because
read error is essentialy the same as garbage given back, right?

...plus, this is significant difference from logical-logging
filesystems, no?

Should this go to Documentation/, somewhere?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
