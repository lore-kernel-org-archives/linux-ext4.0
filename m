From: Pavel Machek <pavel@ucw.cz>
Subject: fsck more often when powerfail is detected (was Re: wishful
	thinking about atomic, multi-sector or full MD stripe width, writes
	in storage)
Date: Sun, 4 Apr 2010 15:47:29 +0200
Message-ID: <20100404134729.GA1388@ucw.cz>
References: <20090831132139.GA5425@infradead.org> <4A9F230F.40707@redhat.com> <m3ab1cp9ii.fsf@intrepid.localdomain> <4A9FA5F2.9090704@redhat.com> <m3ljkwnoct.fsf@intrepid.localdomain> <4A9FC9B3.1080809@redhat.com> <m3ab1cnn7y.fsf@intrepid.localdomain> <4A9FCF6B.1080704@redhat.com> <20090907114534.GP23450@elf.ucw.cz> <20090907131026.GC32427@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754251Ab0DDNrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 09:47:41 -0400
Content-Disposition: inline
In-Reply-To: <20090907131026.GC32427@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > Yes, but ext3 was designed to handle the partial write  (according to
> > tytso).
> 
> I'm not sure what made you think that I said that.  In practice things
> usually work out, as a conseuqence of the fact that ext3 uses physical
> block journaling, but it's not perfect, becase...

Ok; so the journalling actually  is not reliable on many machines --
not even disk drive manufacturers guarantee full block writes AFAICT.

Maybe there's time to reviwe the patch to increase mount count by >1
when journal is replayed, to do fsck more often when powerfails are
present?


> > > Also, when you enable the write cache (MD or not) you are buffering 
> > > multiple MB's of data that can go away on power loss. Far greater (10x) 
> > > the exposure that the partial RAID rewrite case worries about.
> > 
> > Yes, that's what barriers are for. Except that they are not there on
> > MD0/MD5/MD6. They actually work on local sata drives...
> 
> Yes, but ext3 does not enable barriers by default (the patch has been
> submitted but akpm has balked because he doesn't like the performance
> degredation and doesn't believe that Chris Mason's "workload of doom"
> is a common case).  Note though that it is possible for dirty blocks
> to remain in the track buffer for *minutes* without being written to
> spinning rust platters without a barrier.

So we do wrong thing by default. Another reason to do fsck more often
when powerfails are present?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
