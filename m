From: Rob Landley <rob@landley.net>
Subject: Re: fsck more often when powerfail is detected (was Re: wishful thinking about atomic, multi-sector or full MD stripe width, writes in storage)
Date: Sun, 4 Apr 2010 18:58:28 -0500
Message-ID: <201004041858.31482.rob@landley.net>
References: <20090831132139.GA5425@infradead.org> <201004041259.18741.rob@landley.net> <20100404192912.GH18524@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45918
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0DDX6m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 19:58:42 -0400
In-Reply-To: <20100404192912.GH18524@thunk.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sunday 04 April 2010 14:29:12 tytso@mit.edu wrote:
> On Sun, Apr 04, 2010 at 12:59:16PM -0500, Rob Landley wrote:
> > I don't know of a server anywhere that can afford an unscheduled
> > extra four hours of downtime due to the system deciding to fsck
> > itself, and I don't know a Linux laptop user anywhere who would be
> > happy to fire up their laptop and suddenly be told "oh, you can't do
> > anything with it for two hours, and you can't power it down either".
>
> So what I recommend for server class machines is to either turn off
> the automatic fsck's (it's the default, but it's documented and there
> are supported ways of turning it off --- that's hardly developers
> "ramming" it down user's throats), or more preferably, to use LVM, and
> then use a snapshot and running fsck on the snapshot.

Turning off the automatic fsck is what I see people do, yes.

My point is that if you don't force the thing to run memtest86 overnight every 
20 boots, forcing it to run fsck seems a bit silly.

> > I'm all for btrfs coming along and being able to fsck itself behind
> > my back where I don't have to care about it.  (Although I want to
> > tell it _not_ to do that when on battery power.)
>
> You can do this with ext3/ext4 today, now.  Just take a look at
> e2croncheck in the contrib directory of e2fsprogs.  Changing it to not
> do this when on battery power is a trivial exercise.
>
> > My laptop power fails all the time, due to battery exhaustion.  Back
> > under KDE it was decent about suspending when it was ran low on
> > power, but ever since KDE 4 came out and I had to switch to XFCE,
> > it's using the gnome infrastructure, which collects funky statistics
> > and heuristics but can never quite save them to disk because
> > suddenly running out of power when it thinks it's got 20 minutes
> > left doesn't give it the opportunity to save its database.  So it'll
> > never auto-suspend, just suddenly die if I don't hit the button.
>
> Hmm, why are you running on battery so often?

Personal working style?

When I was in Pittsburgh, I used the laptop on the bus to and from work every 
day.  Here in Austin, my laundromat has free wifi.  It also gets usable free 
wifi from the coffee shop to the right, the japanese restaurant to the left, and 
the ice cream shop across the street.  (And when I'm not in a wifi area, my 
cell phone can bluetooth associate to give me net access too.)

I like coffee shops.  (Of course the fact that if I try to work from home I 
have to fight off the affections of four cats might have something to do with it 
too...)

> I make a point of
> running connected to the AC mains whenever possible, because a LiOn
> battery only has about 200 full-cycle charge/discharges in it, and
> given the cost of LiOn batteries, basically each charge/discharge
> cycle costs a dollar each.

Actually the battery's about $50, so that would be 25 cents each.

My laptop is on its third battery.  It's also on its third hard drive.

> So I only run on batteries when I
> absolutely have to, and in practice it's rare that I dip below 30% or
> so.

Actually I find the suckers die just as quickly from simply being plugged in 
and kept hot by the electronics, and never used so they're pegged at 100% with 
slight trickle current beyond that constantly overcharging them.

> > As a result of one of these, two large media files in my "anime"
> > subdirectory are not only crosslinked, but the common sector they
> > share is bad.  (It ran out of power in the act of writing that
> > sector.  I left it copying large files to the drive and forgot to
> > plug it in, and it did the loud click emergency park and power down
> > thing when the hardware voltage regulator tripped.)
>
> So e2fsck would fix the cross-linking.  We do need to have some better
> tools to do forced rewrite of sectors that have gone bad in a HDD.  It
> can be done by using badblocks -n, but translating the sector number
> emitted by the device driver (which for some drivers is relative to
> the beginning of the partition, and for others is relative to the
> beginning of the disk).  It is possible to run badblocks -w on the
> whole disk, of course, but it's better to just run it on the specific
> block in question.

The point I was trying to make is that running "preemptive" fsck is imposing a 
significant burden on users in an attempt to find purely theoretical problems, 
with the expectation that a given run will _not_ find them.  I've had systems 
taken out by actual hardware issues often enough that keeping good backups and 
being prepared to lose the entire laptop at any time is just common sense.

I knocked my laptop into the bathtub last month.  Luckily there wasn't any 
water in the thing at the time, but it made a very loud bang when it hit, and 
it was on at the time.  (Checked dmesg several times over the next few days 
and it didn't start spitting errors at me, so that's something...)

> > I'm much more comfortable living with this until I can get a new laptop
> > than with the idea of running fsck on the system and letting it do who
> > knows what it response to something that is not actually a problem.
>
> Well, it actually is a problem.  And there may be other problems
> hiding that you're not aware of.  Running "badblocks -b 4096 -n" may
> discover other blocks that have failed, and you can then decide
> whether you want to let fsck fix things up.  If you don't, though,
> it's probably not fair to blame ext3 or e2fsck for any future
> failures (not that it's likely to stop you :-).

I'm not blaming ext2.  I'm saying I've spilled sodas into my working machines 
on so many occasions over the years I've lost _track_.  (The vast majority of 
'em survived, actually.)

Random example of current cascading badness: The latch sensor on my laptop is 
no longer debounced.  That happened when I upgraded to Ubuntu 9.04 but I'm not 
sure how that _can_ screw that up, you'd think the bios would be in charge of 
that.  So anyway, it now has a nasty habit of waking itself up in the nice 
insulated pocket in my backpack and then shutting itself down hard five minutes 
later when the thermal sensors trip (at the bios level I think, not in the 
OS).  So I now regularly suspend to disk instead of to ram because that way it 
can't spuriously wake itself back up just because it got jostled slightly.  
Except that when it resumes from disk, the console it suspended in is totally 
misprogrammed (vertical lines on what it _thinks_ is text mode), and sometimes 
the chip is so horked I can hear the sucker making a screeching noise.  The 
easy workarond is to ctrl-alt-F1 and suspend from a text console, then Ctrl-
alt-f7 gets me back to the desktop.  But going back to that text console 
remembers the misprogramming, and I get vertical lines and an adible whine 
coming from something that isn't a speaker.  (Luckly cursor-up and enter works 
to re-suspend, so I can just sacrifice one console to the suspend bug.)

The _fun_ part is that the last system I had where X11 regularly misprogramed 
it so badly I could _hear_ the video chip, said video chip eventually 
overheated and melted bits of the motherboard.  (That was a toshiba laptop.  
It took out the keyboard controller first, and I used it for a few months with 
an external keyboard until the whole thing just went one day.  The display you 
get when your video chip finally goes can be pretty impressive.  Way prettier 
than the time I was caught in a thunderstorm and my laptop got soaked and two 
vertical sections of the display were flickering white while the rest was 
displaying normally -- that system actally started working again when it dried 
out...)

It just wouldn't be a Linux box to me if I didn't have workarounds for the 
side effects of my workarounds.

Anyway, this is the perspective from which I say that the fsck to look for 
purely theoretical badness on my otherwise perfect system is not worth 2 hours 
to never find anything wrong.

If Ubuntu's little upgrade icon had a "recommend fsck" thing that lights up 
every 3 months which I could hit some weekend when I was going out anyway, 
that would be one thing.  But "Ah, Ubuntu 9.04 moved DRM from X11 into the 
kernel and the Intel 945 3D driver is now psychotic and it froze your machine 
for the second time this week.  Since you're rebooting anyway, you won't mind 
if I add an extra 3 hours to the process"...?  That stopped really being a 
viable assumption some time before hard drives were regularly measured in 
terabytes.

> 	      	   	       	       	   - Ted

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
