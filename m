From: Rob Landley <rob@landley.net>
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3: document conditions when reliable operation is possible)
Date: Wed, 2 Sep 2009 18:00:48 -0500
Message-ID: <200909021800.51096.rob@landley.net>
References: <20090826001645.GN4300@elf.ucw.cz> <20090902201210.GC1840@ucw.cz> <4A9ED8AB.5080003@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@ucw.cz>, david@lang.hm,
	Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <4A9ED8AB.5080003@redhat.com>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 02 September 2009 15:42:19 Ric Wheeler wrote:
> On 09/02/2009 04:12 PM, Pavel Machek wrote:
> >>>> people aren't objecting to better documentation, they are objecting to
> >>>> misleading documentation.
> >>>
> >>> Actually Ric is. He's trying hard to make RAID5 look better than it
> >>> really is.
> >>
> >> I object to misleading and dangerous documentation that you have
> >> proposed. I spend a lot of time working in data integrity, talking and
> >> writing about it so I care deeply that we don't misinform people.
> >
> > Yes, truth is dangerous. To vendors selling crap products.
>
> Pavel, you have no information and an attitude of not wanting to listen to
> anyone who has real experience or facts. Not just me, but also Ted and
> others.
>
> Totally pointless to reply to you further.

For the record, I've been able to follow Pavel's arguments, and I've been able 
to follow Ted's arguments.  But as far as I can tell, you're arguing about a 
different topic than the rest of us.

There's a difference between:

A) This filesystem was corrupted because the underlying hardware is permanently 
damaged, no longer functioning as it did when it was new, and never will 
again.

B) We had a transient glitch that ate the filesystem.  The underlying hardware 
is as good as new, but our data is gone.

You can argue about whether or not "new" was ever any good, but Linux has run 
on PC-class hardware from day 1.  Sure PC-class hardware remains crap in many 
different ways, but this is not a _new_ problem.  Refusing to work around what 
people actually _have_ and insisting we get a better class of user instead 
_is_ a new problem, kind of a disturbing one.

USB keys are the modern successor to floppy drives, and even now 
Documentation/blockdev/floppy.txt is still full of some of the torturous 
workarounds implemented for that over the past 2 decades.  The hardware 
existed, and instead of turning up their nose at it they made it work as best 
they could.

Perhaps what's needed for the flash thing is a userspace package, the way 
mdutils made floppies a lot more usable than the kernel managed at the time.  
For the flash problem perhaps some FUSE thing a bit like mtdblock might be 
nice, a translation layer remapping an arbitrary underlying block device into 
larger granularity chunks and being sure to do the "write the new one before 
you erase the old one" trick that so many hardware-only flash devices _don't_, 
and then maybe even use Pavel's crash tool to figure out the write granularity 
of various sticks and ship it with a whitelist people can email updates to so 
we don't have to guess large.  (Pressure on the USB vendors to give us a "raw 
view" extension bypassing the "pretend to be a hard drive, with remapping" 
hardware in future devices would be nice too, but won't help any of the 
hardware out in the field.  I'm not sure that block remapping wouldn't screw up 
_this_ approach either, but it's an example of something that culd be 
_tried_.)

However, thinking about how to _fix_ a problem is predicated on acknowledging 
that there actually _is_ a problem.  "The hardware is not physically damaged 
but your data was lost" sounds to me like a software problem, and thus 
something software could at least _attempt_ to address.  "There's millions of 
'em, Linux can't cope" doesn't seem like a useful approach.

I already addressed the software raid thing last post.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
