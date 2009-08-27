From: Rob Landley <rob@landley.net>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is possible
Date: Thu, 27 Aug 2009 02:34:40 -0500
Message-ID: <200908270234.41996.rob@landley.net>
References: <4A92F6FC.4060907@redhat.com> <200908270106.15032.rob@landley.net> <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33164
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbZH0Hem (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Aug 2009 03:34:42 -0400
In-Reply-To: <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thursday 27 August 2009 01:54:30 david@lang.hm wrote:
> On Thu, 27 Aug 2009, Rob Landley wrote:
> > On Wednesday 26 August 2009 07:28:13 Theodore Tso wrote:
> >> On Wed, Aug 26, 2009 at 01:17:52PM +0200, Pavel Machek wrote:
> >>>> Metadata takes up such a small part of the disk that fscking
> >>>> it and finding it to be OK is absolutely no guarantee that
> >>>> the data on the filesystem has not been horribly mangled.
> >>>>
> >>>> Personally, what I care about is my data.
> >>>>
> >>>> The metadata is just a way to get to my data, while the data
> >>>> is actually important.
> >>>
> >>> Personally, I care about metadata consistency, and ext3 documentation
> >>> suggests that journal protects its integrity. Except that it does not
> >>> on broken storage devices, and you still need to run fsck there.
> >>
> >> Caring about metadata consistency and not data is just weird, I'm
> >> sorry.  I can't imagine anyone who actually *cares* about what they
> >> have stored, whether it's digital photographs of child taking a first
> >> step, or their thesis research, caring about more about the metadata
> >> than the data.  Giving advice that pretends that most users have that
> >> priority is Just Wrong.
> >
> > I thought the reason for that was that if your metadata is horked,
> > further writes to the disk can trash unrelated existing data because it's
> > lost track of what's allocated and what isn't.  So back when the
> > assumption was "what's written stays written", then keeping the metadata
> > sane was still darn important to prevent normal operation from
> > overwriting unrelated existing data.
> >
> > Then Pavel notified us of a situation where interrupted writes to the
> > disk can trash unrelated existing data _anyway_, because the flash block
> > size on the 16 gig flash key I bought retail at Fry's is 2 megabytes, and
> > the filesystem thinks it's 4k or smaller.  It seems like what _broke_ was
> > the assumption that the filesystem block size >= the disk block size, and
> > nobody noticed for a while. (Except the people making jffs2 and friends,
> > anyway.)
> >
> > Today we have cheap plentiful USB keys that act like hard drives, except
> > that their write block size isn't remotely the same as hard drives', but
> > they pretend it is, and then the block wear levelling algorithms fuzz
> > things further.  (Gee, a drive controller lying about drive geometry, the
> > scsi crowd should feel right at home.)
>
> actually, you don't know if your USB key works that way or not.

Um, yes, I think I do.

> Pavel has ssome that do, that doesn't mean that all flash drives do

Pretty much all the ones that present a USB disk interface to the outside 
world and then thus have to do hardware levelling.  Here's Valerie Aurora on 
the topic:

http://valhenson.livejournal.com/25228.html

>Let's start with hardware wear-leveling. Basically, nearly all practical
> implementations of it suck. You'd imagine that it would spread out writes
> over all the blocks in the drive, only rewriting any particular block after
> every other block has been written. But I've heard from experts several
> times that hardware wear-leveling can be as dumb as a ring buffer of 12
> blocks; each time you write a block, it pulls something out of the queue
> and sticks the old block in. If you only write one block over and over,
> this means that writes will be spread out over a staggering 12 blocks! My
> direct experience working with corrupted flash with built-in wear-leveling
> is that corruption was centered around frequently written blocks (with
> interesting patterns resulting from the interleaving of blocks from
> different erase blocks). As a file systems person, I know what it takes to
> do high-quality wear-leveling: it's called a log-structured file system and
> they are non-trivial pieces of software. Your average consumer SSD is not
> going to have sufficient hardware to implement even a half-assed
> log-structured file system, so clearly it's going to be a lot stupider than
> that.

Back to you:

> when you do a write to a flash drive you have to do the following items
>
> 1. allocate an empty eraseblock to put the data on
>
> 2. read the old eraseblock
>
> 3. merge the incoming write to the eraseblock
>
> 4. write the updated data to the flash
>
> 5. update the flash trnslation layer to point reads at the new location
> instead of the old location.
>
> now if the flash drive does things in this order you will not loose any
> previously written data.

That's what something like jffs2 will do, sure.  (And note that mounting those 
suckers is slow while it reads the whole disk to figure out what order to put 
the chunks in.)

However, your average consumer level device A) isn't very smart, B) is judged 
almost entirely by price/capacity ratio and thus usually won't even hide 
capacity for bad block remapping.  You expect them to have significant hidden 
capacity to do safer updates with when customers aren't demanding it yet?

> if the flash drive does step 5 before it does step 4, then you have a
> window where a crash can loose data (and no btrfs won't survive any better
> to have a large chunk of data just disappear)
>
> it's possible that some super-cheap flash drives

I've never seen one that presented a USB disk interface that _didn't_ do this.  
(Not that this observation means much.)  Neither the windows nor the Macintosh 
world is calling for this yet.  Even the Linux guys barely know about it.  And 
these are the same kinds of manufacturers that NOPed out the flush commands to 
make their benchmarks look better...

> but if the device doesn't have a flash translation layer, then repeated
> writes to any one sector will kill the drive fairly quickly. (updates to
> the FAT would kill the sectors the FAT, journal, root directory, or
> superblock lives in due to the fact that every change to the disk requires
> an update to this file for example)

Yup.  It's got enough of one to get past the warantee, but beyond that they're 
intended for archiving and sneakernet, not for running compiles on.

> > That said, ext3's assumption that filesystem block size always >= disk
> > update block size _is_ a fundamental part of this problem, and one that
> > isn't shared by things like jffs2, and which things like btrfs might be
> > able to address if they try, by adding awareness of the real media update
> > granularity to their node layout algorithms.  (Heck, ext2 has a stripe
> > size parameter already. Does setting that appropriately for your raid
> > make this suck less?  I haven't heard anybody comment on that one yet...)
>
> I thought that that assumption was in the VFS layer, not in any particular
> filesystem

The VFS layer cares about how to talk to the backing store?  I thought that 
was the filesystem driver's job...

I wonder how jffs2 gets around it, then?  (Or for that matter, squashfs...)

> David Lang

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
