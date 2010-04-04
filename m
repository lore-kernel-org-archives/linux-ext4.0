From: Pavel Machek <pavel@ucw.cz>
Subject: Re: fsck more often when powerfail is detected (was Re: wishful
 thinking about atomic, multi-sector or full MD stripe width, writes in
 storage)
Date: Sun, 4 Apr 2010 20:45:46 +0200
Message-ID: <20100404184546.GA18873@elf.ucw.cz>
References: <20090831132139.GA5425@infradead.org>
 <20090907131026.GC32427@mit.edu>
 <20100404134729.GA1388@ucw.cz>
 <201004041259.18741.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Rob Landley <rob@landley.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201004041259.18741.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 2010-04-04 12:59:16, Rob Landley wrote:
> On Sunday 04 April 2010 08:47:29 Pavel Machek wrote:
> > Maybe there's time to reviwe the patch to increase mount count by >1
> > when journal is replayed, to do fsck more often when powerfails are
> > present?
> 
> Wow, you mean there are Linux users left who _don't_ rip that out?

Yes, there are. It actually helped pinpoint corruption here, 4 time it
was major corruption.

And yes, I'd like fsck more often, when they are power failures and
less often when the shutdowns are orderly...

I'm not sure of what right intervals between check are for you, but
I'd say that fsck once a year or every 100 mounts or every 10 power
failures is probably good idea for everybody...

> The auto-fsck stuff is an instance of "we the developers know what you the 
> users need far more than you ever could, so let me ram this down your throat".  
> I don't know of a server anywhere that can afford an unscheduled extra four 
> hours of downtime due to the system deciding to fsck itself, and I don't know 
> a Linux laptop user anywhere who would be happy to fire up their laptop and 
> suddenly be told "oh, you can't do anything with it for two hours, and you 
> can't power it down either".

On laptop situation is easy. Pull the plug, hit reset, wait for fsck,
plug AC back in. Done that, too :-).

Yep, it would be nice if fsck had "escape" button.

> I'm all for btrfs coming along and being able to fsck itself behind my back 
> where I don't have to care about it.  (Although I want to tell it _not_ to do 
> that when on battery power.)  But the "fsck lottery" at powerup is just 
> stupid.

fsck lottery. :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
