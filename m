From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Mon, 23 Mar 2009 12:00:19 +0100
Message-ID: <20090323110019.GD17681@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316123051.GJ2405@elf.ucw.cz> <20090316194057.GA27897@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57888 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZCWK5h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2009 06:57:37 -0400
Content-Disposition: inline
In-Reply-To: <20090316194057.GA27897@silver.sucs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 2009-03-16 19:40:57, Sitsofe Wheeler wrote:
> On Mon, Mar 16, 2009 at 01:30:51PM +0100, Pavel Machek wrote:
> > +	Unfortunately, none of the cheap USB/SD flash cards I've seen
> > +	do behave like this, and are thus unsuitable for all Linux
> > +	filesystems I know.
> 
> When you say Linux filesystems do you mean "filesystems originally
> designed on Linux" or do you mean "filesystems that Linux supports"?

"Linux filesystems I know" :-). No filesystem that Linux supports,
AFAICT.

> Additionally whatever the answer, people are going to need help
> answering the "which is the least bad?" question and saying what's not
> good without offering alternatives is only half helpful... People need
> to put SOMETHING on these cheap (and not quite so cheap)
> devices... The

According to me, people should just AVOID those devices. I don't plan
to point the "least bad"; its still bad.

> > +	   hdparm -I reports disk features. If you have "Native
> > +	   Command Queueing" is the feature you are looking for.
> 
> The document makes it sound like nearly everything bar battery backed
> hardware RAIDed SCSI disks (with perfect firmware) is bad  - is this
> the intent?

Battery backed RAID should be ok, as should be plain single SATA drive.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
