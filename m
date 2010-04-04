From: Rob Landley <rob@landley.net>
Subject: Re: fsck more often when powerfail is detected (was Re: wishful thinking about atomic, multi-sector or full MD stripe width, writes in storage)
Date: Sun, 4 Apr 2010 12:59:16 -0500
Message-ID: <201004041259.18741.rob@landley.net>
References: <20090831132139.GA5425@infradead.org> <20090907131026.GC32427@mit.edu> <20100404134729.GA1388@ucw.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Hellwig <hch@infradead.org>, Mark Lord <lkml@rtr.ca>,
	Michael Tokarev <mjt@tls.msk.ru>, david@lang.hm,
	NeilBrown <neilb@suse.de>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100404134729.GA1388@ucw.cz>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sunday 04 April 2010 08:47:29 Pavel Machek wrote:
> Maybe there's time to reviwe the patch to increase mount count by >1
> when journal is replayed, to do fsck more often when powerfails are
> present?

Wow, you mean there are Linux users left who _don't_ rip that out?

The auto-fsck stuff is an instance of "we the developers know what you the 
users need far more than you ever could, so let me ram this down your throat".  
I don't know of a server anywhere that can afford an unscheduled extra four 
hours of downtime due to the system deciding to fsck itself, and I don't know 
a Linux laptop user anywhere who would be happy to fire up their laptop and 
suddenly be told "oh, you can't do anything with it for two hours, and you 
can't power it down either".

I keep my laptop backed up to an external terabyte USB drive and the volatile 
subset of it to a network drive (rsync is great for both), and when it dies, 
it dies.  But I've never lost data due to an issue fsck would have fixed.  I've 
lost data to disks overheating, disks wearing out, disks being run undervolt 
because the cat chewed on the power supply cord... I've copied floppy images to 
/dev/hda instead of /dev/fd0... I even ran over my laptop with my car once.  
(Amazingly enough, that hard drive survived.)

But fsck has never once protected any data of mine, that I am aware of, since 
journaling was introduced.

I'm all for btrfs coming along and being able to fsck itself behind my back 
where I don't have to care about it.  (Although I want to tell it _not_ to do 
that when on battery power.)  But the "fsck lottery" at powerup is just 
stupid.

> > > > Also, when you enable the write cache (MD or not) you are buffering
> > > > multiple MB's of data that can go away on power loss. Far greater
> > > > (10x) the exposure that the partial RAID rewrite case worries about.
> > >
> > > Yes, that's what barriers are for. Except that they are not there on
> > > MD0/MD5/MD6. They actually work on local sata drives...
> >
> > Yes, but ext3 does not enable barriers by default (the patch has been
> > submitted but akpm has balked because he doesn't like the performance
> > degredation and doesn't believe that Chris Mason's "workload of doom"
> > is a common case).  Note though that it is possible for dirty blocks
> > to remain in the track buffer for *minutes* without being written to
> > spinning rust platters without a barrier.
>
> So we do wrong thing by default. Another reason to do fsck more often
> when powerfails are present?

My laptop power fails all the time, due to battery exhaustion.  Back under KDE 
it was decent about suspending when it was ran low on power, but ever since 
KDE 4 came out and I had to switch to XFCE, it's using the gnome 
infrastructure, which collects funky statistics and heuristics but can never 
quite save them to disk because suddenly running out of power when it thinks 
it's got 20 minutes left doesn't give it the opportunity to save its database.  
So it'll never auto-suspend, just suddenly die if I don't hit the button.

As a result of one of these, two large media files in my "anime" subdirectory 
are not only crosslinked, but the common sector they share is bad.  (It ran 
out of power in the act of writing that sector.  I left it copying large files 
to the drive and forgot to plug it in, and it did the loud click emergency 
park and power down thing when the hardware voltage regulator tripped.)

This corruption has been there for a year now.  Presumably if it overwrote 
that sector it might recover (perhaps by allocating one of the spares), but 
the drive firmware has proven unwilling to do so in response to _reading_ the 
bad sector, and I'm largely ignoring it because it's by no means the worst 
thing wrong with this laptop's hardware, and some glorious day I'll probably 
break down and buy a macintosh.  The stuff I have on it's backed up, and in the 
year since it hasn't developed a second bad sector and I haven't deleted those 
files.  (Yes, I could replace the hard drive _again_ but this laptop's on its 
third hard drive already and it's just not worth the effort.)

I'm much more comfortable living with this until I can get a new laptop than 
with the idea of running fsck on the system and letting it do who knows what 
it response to something that is not actually a problem.

> 									Pavel

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
