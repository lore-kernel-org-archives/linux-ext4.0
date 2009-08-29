From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Sat, 29 Aug 2009 12:02:02 +0200
Message-ID: <20090829100202.GG1634__23351.4108964757$1251542610$gmane$org@ucw.cz>
References: <20090825225114.GE4300@elf.ucw.cz> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <200908270019.04231.rob@landley.net> <20090827122423.GO6997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57105 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZH2KnC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Aug 2009 06:43:02 -0400
Content-Disposition: inline
In-Reply-To: <20090827122423.GO6997@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 2009-08-27 08:24:23, Theodore Tso wrote:
> On Thu, Aug 27, 2009 at 12:19:02AM -0500, Rob Landley wrote:
> > > To me, this isn't a particularly interesting or newsworthy point,
> > > since a competent system administrator
> > 
> > I'm a bit concerned by the argument that we don't need to document
> > serious pitfalls because every Linux system has a sufficiently
> > competent administrator they already know stuff that didn't even
> > come up until the second or third day it was discussed on lkml.
> 
> I'm not convinced that information which needs to be known by System
> Administrators is best documented in the kernel Documentation
> directory.  Should there be a HOWTO document on stuff like that?

It is not only for system administrators; I was trying to find out if
kernel is buggy, and that should be in kernel tree.


> > If "degraded array" just means "don't have a replacement disk yet",
> > then it sounds like what Pavel wants to document is "don't write to
> > a degraded array at all, because power failures can cost you data
> > due to write granularity being larger than filesystem block size".
> > (Which still comes as news to some of us, and you need a way to
> > remount mount the degraded array read only until the sysadmin can
> > fix it.)
> 
> If you want to document that as a property of RAID arrays, sure.  But
> it's not something that should live in Documentation/filesystems/ext2.txt
> and Documentation/filesystems/ext3.txt.  The MD RAID howto might be a

ext3 documentation states that journal protects fs integrity on
powerfail. If you don't want to talk about storage stacks, perhaps
that should be removed?

Now... You mocked me up for 'ext3 expects disks to behave like disks
(alarmist)'. I actually believe that should be written somewhere. ext3
depends on fairly subtle storage disk characteristics, and many common
configs just do not meet the expectations (missing barriers is most
common, followed by collateral damage).

Maybe not documenting that was okay 10 years ago, but with all the USB
sticks and raid arrays around, its just sloppy. Because those
characteristics are not documented, storage stack authors do not know
what they have to guarantee, and the result is bad. See for example
nbd -- it does not propagate barriers and is therefore unsafe.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
