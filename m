From: Pavel Machek <pavel@ucw.cz>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 09:51:35 +0200
Message-ID: <20090830075135.GA1874__41248.7655798488$1251618778$gmane$org@ucw.cz>
References: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswi
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59618 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZH3Hvp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 03:51:45 -0400
Content-Disposition: inline
In-Reply-To: <20090828120854.GA8153@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

> > From: Theodore Tso <tytso@mit.edu>
> > 
> > Document that many devices are too broken for filesystems to protect
> > data in case of powerfail.
> > 
> > Signed-of-by: Pavel Machek <pavel@ucw.cz> 
> 
> NACK.  I didn't write this patch, and it's disingenuous for you to try
> to claim that I authored it.

Well, you did write original text, so I wanted to give you
credit. Sorry.

> While Neil Brown's corrections are minimally necessary so the text is
> at least technically *correct*, it's still not the right advice to
> give system administrators.  It's better than the fear-mongering
> patches you had proposed earlier, but what would be better *still* is
> telling people why running with degraded RAID arrays is bad, and to
> give them further tips about how to use RAID arrays safely.

Maybe this belongs to Doc*/filesystems, and more detailed RAID
description should go to md description?

> To use your ABS brakes analogy, just becase it's not safe to rely on
> ABS brakes if the "check brakes" light is on, that doesn't justify
> writing something alarmist which claims that ABS brakes don't work
> 100% of the time, don't use ABS brakes, they're broken!!!!

If it only was this simple. We don't have 'check brakes' (aka
'journalling ineffective') warning light. If we had that, I would not
have problem.

It is rather that your ABS brakes are ineffective if 'check engine'
(RAID degraded) is lit. And yes, running with 'check engine' for
extended periods may be bad idea, but I know people that do
that... and I still hope their brakes work (and believe they should
have won suit for damages should their ABS brakes fail). 

> That's just silly.  What we should be telling people instead is (a)
> pay attention to the check brakes light (just as you should pay
> attention to the RAID array is degraded warning), and (b) while ABS

'your RAID array is degraded' is very counter intuitive way to say
'...and btw your journalling is no longer effective, either'.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
