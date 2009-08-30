From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Sun, 30 Aug 2009 09:01:09 +0200
Message-ID: <20090830070109.GC1417__7007.41726109317$1251615690$gmane$org@ucw.cz>
References: <20090825235359.GJ4300@elf.ucw.cz> <4A947DA9.2080906@redhat.com> <20090826001645.GN4300@elf.ucw.cz> <4A948259.40007@redhat.com> <20090826010018.GA17684@mit.edu> <4A948C94.7040103@redhat.com> <20090826025849.GF32712@mit.edu> <4A9510D2.1090704@redhat.com> <20090826111208.GA26595@elf.ucw.cz> <20090826122311.GH32712@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48900 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZH3HBP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 03:01:15 -0400
Content-Disposition: inline
In-Reply-To: <20090826122311.GH32712@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 2009-08-26 08:23:11, Theodore Tso wrote:
> On Wed, Aug 26, 2009 at 01:12:08PM +0200, Pavel Machek wrote:
> > > I agree that this is not an interesting (or likely) scenario, certainly  
> > > when compared to the much more frequent failures that RAID will protect  
> > > against which is why I object to the document as Pavel suggested. It  
> > > will steer people away from using RAID and directly increase their  
> > > chances of losing their data if they use just a single disk.
> > 
> > So instead of fixing or at least documenting known software deficiency
> > in Linux MD stack, you'll try to surpress that information so that
> > people use more of raid5 setups?
> 
> First of all, it's not a "known software deficiency"; you can't do
> anything about a degraded RAID array, other than to replace the failed
> disk. 

You could add journal to raid5.

> "ext2 and ext3 have this surprising dependency that disks act like
> disks".  (alarmist)

AFAICT, you mount block device, not disk. Many block devices fail the
test. And since users (and block device developers) do not  know in
detail how disks behave, it is hard to blame them... ("you may corrupt
sector you are writing to and ext3 handles that ok" was surprise for
me, for example).

					
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
