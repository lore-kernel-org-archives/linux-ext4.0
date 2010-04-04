From: tytso@mit.edu
Subject: Re: fsck more often when powerfail is detected (was Re: wishful
 thinking about atomic, multi-sector or full MD stripe width, writes in
 storage)
Date: Sun, 4 Apr 2010 15:29:12 -0400
Message-ID: <20100404192912.GH18524@thunk.org>
References: <20090831132139.GA5425@infradead.org>
 <20090907131026.GC32427@mit.edu>
 <20100404134729.GA1388@ucw.cz>
 <201004041259.18741.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	NeilBrown <neilb@suse.de>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201004041259.18741.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 04, 2010 at 12:59:16PM -0500, Rob Landley wrote:
> I don't know of a server anywhere that can afford an unscheduled
> extra four hours of downtime due to the system deciding to fsck
> itself, and I don't know a Linux laptop user anywhere who would be
> happy to fire up their laptop and suddenly be told "oh, you can't do
> anything with it for two hours, and you can't power it down either".

So what I recommend for server class machines is to either turn off
the automatic fsck's (it's the default, but it's documented and there
are supported ways of turning it off --- that's hardly developers
"ramming" it down user's throats), or more preferably, to use LVM, and
then use a snapshot and running fsck on the snapshot.

> I'm all for btrfs coming along and being able to fsck itself behind
> my back where I don't have to care about it.  (Although I want to
> tell it _not_ to do that when on battery power.)  

You can do this with ext3/ext4 today, now.  Just take a look at
e2croncheck in the contrib directory of e2fsprogs.  Changing it to not
do this when on battery power is a trivial exercise.  

> My laptop power fails all the time, due to battery exhaustion.  Back
> under KDE it was decent about suspending when it was ran low on
> power, but ever since KDE 4 came out and I had to switch to XFCE,
> it's using the gnome infrastructure, which collects funky statistics
> and heuristics but can never quite save them to disk because
> suddenly running out of power when it thinks it's got 20 minutes
> left doesn't give it the opportunity to save its database.  So it'll
> never auto-suspend, just suddenly die if I don't hit the button.

Hmm, why are you running on battery so often?  I make a point of
running connected to the AC mains whenever possible, because a LiOn
battery only has about 200 full-cycle charge/discharges in it, and
given the cost of LiOn batteries, basically each charge/discharge
cycle costs a dollar each.  So I only run on batteries when I
absolutely have to, and in practice it's rare that I dip below 30% or
so.

> As a result of one of these, two large media files in my "anime"
> subdirectory are not only crosslinked, but the common sector they
> share is bad.  (It ran out of power in the act of writing that
> sector.  I left it copying large files to the drive and forgot to
> plug it in, and it did the loud click emergency park and power down
> thing when the hardware voltage regulator tripped.)

So e2fsck would fix the cross-linking.  We do need to have some better
tools to do forced rewrite of sectors that have gone bad in a HDD.  It
can be done by using badblocks -n, but translating the sector number
emitted by the device driver (which for some drivers is relative to
the beginning of the partition, and for others is relative to the
beginning of the disk).  It is possible to run badblocks -w on the
whole disk, of course, but it's better to just run it on the specific
block in question.

> I'm much more comfortable living with this until I can get a new laptop than 
> with the idea of running fsck on the system and letting it do who knows what 
> it response to something that is not actually a problem.

Well, it actually is a problem.  And there may be other problems
hiding that you're not aware of.  Running "badblocks -b 4096 -n" may
discover other blocks that have failed, and you can then decide
whether you want to let fsck fix things up.  If you don't, though,
it's probably not fair to blame ext3 or e2fsck for any future
failures (not that it's likely to stop you :-).

	      	   	       	       	   - Ted
