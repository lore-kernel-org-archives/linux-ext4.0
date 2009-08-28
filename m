From: Theodore Tso <tytso@mit.edu>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Date: Fri, 28 Aug 2009 08:08:54 -0400
Message-ID: <20090828120854.GA8153@mit.edu>
References: <20090828064449.GA27528@elf.ucw.cz> <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz> <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Rob Landley <rob@landley.net>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>, NeilBrown <neilb@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090828064449.GA27528@elf.ucw.cz>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 28, 2009 at 08:44:49AM +0200, Pavel Machek wrote:
> From: Theodore Tso <tytso@mit.edu>
> 
> Document that many devices are too broken for filesystems to protect
> data in case of powerfail.
> 
> Signed-of-by: Pavel Machek <pavel@ucw.cz> 

NACK.  I didn't write this patch, and it's disingenuous for you to try
to claim that I authored it.

You took text I wrote from the *middle* of an e-mail discussion and
you ignored multiple corrections to typo's that I made --- typo's that
I would have corrected if I had ultimately decided to post this as a
patch, which I did NOT.

While Neil Brown's corrections are minimally necessary so the text is
at least technically *correct*, it's still not the right advice to
give system administrators.  It's better than the fear-mongering
patches you had proposed earlier, but what would be better *still* is
telling people why running with degraded RAID arrays is bad, and to
give them further tips about how to use RAID arrays safely.

To use your ABS brakes analogy, just becase it's not safe to rely on
ABS brakes if the "check brakes" light is on, that doesn't justify
writing something alarmist which claims that ABS brakes don't work
100% of the time, don't use ABS brakes, they're broken!!!!

The first part of it is true, since ABS brakes can suffer mechnical
failure.  But what we should be telling drivers is, "if the 'check
brakes' light comes on, don't keep driving with it, go to a garage and
get it fixed!!!".  Similarly, if you get a notice that your RAID is
running in degraded mode, you've already suffered one failure; you
won't survive another failure, so fix that issue ASAP!

If you're really paranoid, you could decide to "pull over to the side
of the road"; that is, you could stop writing to the RAID array as
soon as possible, and then get the the RAID array rebuilt before
proceeding.  That can reduce the chances of a second failure.  But in
the real world, there are costs associated with taking a production
server off-line, and the prudent system administrator has to do a
risk-reward tradeoff.  A better approach might to have the array
configured with a hot spare, and to regularly scrub the array, and
configure the RAID array with either a battery backup or a UPS.  And
hot-swap drives might not be a bad idea, too.

But in any case, just because ABS brakes and RAID arrays can suffer
failures, that doesn't mean you should run around telling people not
to use RAID arrays or RAID arrays are broken.  People are better off
using RAID than not using single disk storage solutions, just as
people are better off using ABS brakes than not.

Your argument basically boils down to, "if you drive like a maniac
when the roads are wet and slippery, ABS brakes might not save your
life.  Since ABS brake might cause you to have a false sense of
security, it's better to tell users that ABS brakes are broken."

That's just silly.  What we should be telling people instead is (a)
pay attention to the check brakes light (just as you should pay
attention to the RAID array is degraded warning), and (b) while ABS
brakes will get you out of some situations with life and limb intact,
they do not repeal that laws of physics (do regular full and
incremental backups; practice disk scrubbing; use UPS's or battery
backups).

							- Ted
