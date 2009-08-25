From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Tue, 25 Aug 2009 15:56:05 -0500
Message-ID: <200908251556.08065.rob@landley.net>
References: <200903121413.04434.rob@landley.net> <20090824205209.GE29763@elf.ucw.cz> <87f94c370908241411r45079c5cx3fc737cf4c3f7d1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Ric Wheeler <rwheeler@redhat.com>,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756189AbZHYU4O@vger.kernel.org>
In-Reply-To: <87f94c370908241411r45079c5cx3fc737cf4c3f7d1e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 24 August 2009 16:11:56 Greg Freemyer wrote:
> > The papers show failures in "once a year" range. I have "twice a
> > minute" failure scenario with flashdisks.
> >
> > Not sure how often "degraded raid5 breaks ext3 atomicity" would bite,
> > but I bet it would be on "once a day" scale.
>
> I agree it should be documented, but the ext3 atomicity issue is only
> an issue on unexpected shutdown while the array is degraded.  I surely
> hope most people running raid5 are not seeing that level of unexpected
> shutdown, let along in a degraded array,
>
> If they are, the atomicity issue pretty strongly says they should not
> be using raid5 in that environment.  At least not for any filesystem I
> know.  Having writes to LBA n corrupt LBA n+128 as an example is
> pretty hard to design around from a fs perspective.

Right now, people think that a degraded raid 5 is equivalent to raid 0.  As 
this thread demonstrates, in the power failure case it's _worse_, due to write 
granularity being larger than the filesystem sector size.  (Just like flash.)

Knowing that, some people might choose to suspend writes to their raid until 
it's finished recovery.  Perhaps they'll set up a system where a degraded raid 
5 gets remounted read only until recovery completes, and then writes go to a 
new blank hot spare disk using all that volume snapshoting or unionfs stuff 
people have been working on.  (The big boys already have hot spare disks 
standing by on a lot of these systems, ready to power up and go without human 
intervention.  Needing two for actual reliability isn't that big a deal.)

Or maybe the raid guys might want to tweak the recovery logic so it's not 
entirely linear, but instead prioritizes dirty pages over clean ones.  So if 
somebody dirties a page halfway through a degraded raid 5, skip ahead to 
recover that chunk first to the new disk first (yes leaving holes, it's not that 
hard to track), and _then_ let the write go through.

But unless people know the issue exists, they won't even start thinking about 
ways to address it. 

> Greg

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
