From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Tue, 25 Aug 2009 13:52:09 -0500
Message-ID: <200908251352.11959.rob@landley.net>
References: <20090312092114.GC6949@elf.ucw.cz> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A92F6FC.4060907@redhat.com>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Monday 24 August 2009 15:24:28 Ric Wheeler wrote:
> Pavel Machek wrote:

> > Actually, ext2 should be able to survive that, no? Error writing ->
> > remount ro -> fsck on next boot -> drive relocates the sectors.
>
> I think that the example and the response are both off base. If your
> head ever touches the platter, you won't be reading from a huge part of
> your drive ever again

It's not quite that simple anymore.

These days, most modern drives add an "overcoat", which is a vapor deposition 
layer of carbon (I.E. diamond) on top of the magnetic media, and then add a 
nanolayer of some kind of nonmagnetic lubricant on top of that.  That protects 
the magnetic layer from physical contact with the head; it takes a pretty 
solid whack to chip through diamond and actually gouge your disk:

  http://www.datarecoverylink.com/understanding_magnetic_media.html

You can also do fun things with various nitridies (carbon nitride, silicon 
nitride, titanium nitride) which are pretty darn tough too, although I dunno 
about their suitability to hard drives:

  http://www.physical-vapor-deposition.com/

So while it _is_ possible to whack your drive and scratch the platter, merely 
"touching" won't do it.  (Laptops wouldn't be feasible if they couldn't cope 
with a little jostling while running.)  In the case of repeated small whacks, 
your heads may actually go first.  (I vaguely recall the little aerofoil wing 
thingy holding up the disk touches first, and can get ground down by repeated 
contact with the diamond layer (despite the lubricant, that just buys time) so 
it gets shorter and shorter and can't reliably keep the head above the disk 
rather than in contact with it.  But I'm kind of stale myself here, not sure 
that's still current.)

Here's a nice youtube video of a 2007 defcon talk from a hard drive recovery 
professional, "What's that Clicking Noise", series starts here:
  http://www.youtube.com/watch?v=vCapEFNZAJ0

And here's that guy's web page:
  http://www.myharddrivedied.com/presentations/index.html

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
