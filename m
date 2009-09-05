From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Sat, 5 Sep 2009 12:34:42 +0200
Message-ID: <20090905103442.GB1341__44485.0244130523$1252146902$gmane$org@ucw.cz>
References: <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz> <20090830152023.GB23828@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswi
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57167 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbZIEKeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Sep 2009 06:34:46 -0400
Content-Disposition: inline
In-Reply-To: <20090830152023.GB23828@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > If it only was this simple. We don't have 'check brakes' (aka
> > 'journalling ineffective') warning light. If we had that, I would not
> > have problem.
> 
> But we do; comptently designed (and in the cast of software RAID,
> competently packaged) RAID subsystems send notifications to the system
> administrator when there is a hard drive failure.  Some hardware RAID
> systems will send a page to the system administrator.  A mid-range
> Areca card has a separate ethernet port so it can send e-mail to the
> administrator, even if the OS is hosed for some reason.

Well, my MMC/uSD cards do not have ethernet ports to remind me that
they are unreliable :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
