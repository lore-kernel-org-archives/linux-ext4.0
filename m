From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Fri, 28 Aug 2009 07:37:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908280702050.6822@asgard.lang.hm>
References: <4A92F6FC.4060907@redhat.com> <200908270106.15032.rob@landley.net> <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm> <200908270234.41996.rob@landley.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Rik van Riel <riel@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Rob Landley <rob@landley.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:42079 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbZH1OiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2009 10:38:24 -0400
In-Reply-To: <200908270234.41996.rob@landley.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 27 Aug 2009, Rob Landley wrote:

> On Thursday 27 August 2009 01:54:30 david@lang.hm wrote:
>> On Thu, 27 Aug 2009, Rob Landley wrote:
>>>
>>> Today we have cheap plentiful USB keys that act like hard drives, except
>>> that their write block size isn't remotely the same as hard drives', but
>>> they pretend it is, and then the block wear levelling algorithms fuzz
>>> things further.  (Gee, a drive controller lying about drive geometry, the
>>> scsi crowd should feel right at home.)
>>
>> actually, you don't know if your USB key works that way or not.
>
> Um, yes, I think I do.
>
>> Pavel has ssome that do, that doesn't mean that all flash drives do
>
> Pretty much all the ones that present a USB disk interface to the outside
> world and then thus have to do hardware levelling.  Here's Valerie Aurora on
> the topic:
>
> http://valhenson.livejournal.com/25228.html
>
>> Let's start with hardware wear-leveling. Basically, nearly all practical
>> implementations of it suck. You'd imagine that it would spread out writes
>> over all the blocks in the drive, only rewriting any particular block after
>> every other block has been written. But I've heard from experts several
>> times that hardware wear-leveling can be as dumb as a ring buffer of 12
>> blocks; each time you write a block, it pulls something out of the queue
>> and sticks the old block in. If you only write one block over and over,
>> this means that writes will be spread out over a staggering 12 blocks! My
>> direct experience working with corrupted flash with built-in wear-leveling
>> is that corruption was centered around frequently written blocks (with
>> interesting patterns resulting from the interleaving of blocks from
>> different erase blocks). As a file systems person, I know what it takes to
>> do high-quality wear-leveling: it's called a log-structured file system and
>> they are non-trivial pieces of software. Your average consumer SSD is not
>> going to have sufficient hardware to implement even a half-assed
>> log-structured file system, so clearly it's going to be a lot stupider than
>> that.
>
> Back to you:

I am not saying that all devices get this right (not by any means), but I 
_am_ saying that devices with wear-leveling _can_ avoid this problem 
entirely

you do not need to do a log-structured filesystem. all you need to do is 
to always write to a new block rather than re-writing a block in place.

even if the disk only does a 12-block rotation for it's wear leveling, 
that is enough for it to not loose other data when you write. to loose 
data you have to be updating a block in place by erasing the old one 
first. _anything_ that writes the data to a new location before it erases 
the old location will prevent you from loosing other data.

I'm all for documenting that this problem can and does exist, but I'm not 
in agreement with documentation that states that _all_ flash drives have 
this problem because (with wear-leveling in a flash translation layer on 
the device) it's not inherent to the technology. so even if all existing 
flash devices had this problem, there could be one released tomorrow that 
didn't.

this is like the problem that flash SSDs had last year that could cause 
them to stall for up to a second on write-heavy workloads. it went from a 
problem that almost every drive for sale had (and something that was 
generally accepted as being a characteristic of SSDs), to being extinct in 
about one product cycle after the problem was identified.

I think this problem will also disappear rapidly once it's publicised.

so what's needed is for someone to come up with a way to test this, let 
people test the various devices, find out how broad the problem is, and 
publicise the results.

personally, I expect that the better disk-replacements will not have a 
problem with this.

I would also be surprised if the larger thumb drives had this problem.

if a flash eraseblock can be used 100k times, then if you use FAT on a 16G 
drive and write 1M files and update the FAT after each file (like you 
would with a camera), the block the FAT is on will die after filling the 
device _6_ times. if it does a 12-block rotation it would die after 72 
times, but if it can move the blocks around the entire device it would 
take 50k times of filling the device.

for a 2G device the numbers would be 50 times with no wear-leveling and 
600 times with 12-block rotation.

so I could see them getting away with this sort of thing for the smaller 
devices, but as the thumb drives get larger, I expect that they will start 
to gain the wear-leveling capabilities that the SSDs have.

>> when you do a write to a flash drive you have to do the following items
>>
>> 1. allocate an empty eraseblock to put the data on
>>
>> 2. read the old eraseblock
>>
>> 3. merge the incoming write to the eraseblock
>>
>> 4. write the updated data to the flash
>>
>> 5. update the flash trnslation layer to point reads at the new location
>> instead of the old location.
>>
>> now if the flash drive does things in this order you will not loose any
>> previously written data.
>
> That's what something like jffs2 will do, sure.  (And note that mounting those
> suckers is slow while it reads the whole disk to figure out what order to put
> the chunks in.)
>
> However, your average consumer level device A) isn't very smart, B) is judged
> almost entirely by price/capacity ratio and thus usually won't even hide
> capacity for bad block remapping.  You expect them to have significant hidden
> capacity to do safer updates with when customers aren't demanding it yet?

this doesn't require filesystem smarts, but it does require a device with 
enough smarts to do bad-block remapping (if it does wear leveling all that 
bad-block remapping would be is not writing to a bad eraseblock, which 
doesn't even require maintaining a map of such blocks, all it would have 
to do is to check if what is on the flash is what it intended to write, if 
it is, use it, if it isn't, try again.

>> if the flash drive does step 5 before it does step 4, then you have a
>> window where a crash can loose data (and no btrfs won't survive any better
>> to have a large chunk of data just disappear)
>>
>> it's possible that some super-cheap flash drives
>
> I've never seen one that presented a USB disk interface that _didn't_ do this.
> (Not that this observation means much.)  Neither the windows nor the Macintosh
> world is calling for this yet.  Even the Linux guys barely know about it.  And
> these are the same kinds of manufacturers that NOPed out the flush commands to
> make their benchmarks look better...

the nature of the FAT filesystem calls for it. I've heard people talk 
about devices that try to be smart enough to take extra care of the blocks 
that the FAT is on

>> but if the device doesn't have a flash translation layer, then repeated
>> writes to any one sector will kill the drive fairly quickly. (updates to
>> the FAT would kill the sectors the FAT, journal, root directory, or
>> superblock lives in due to the fact that every change to the disk requires
>> an update to this file for example)
>
> Yup.  It's got enough of one to get past the warantee, but beyond that they're
> intended for archiving and sneakernet, not for running compiles on.

it doesn't take them being used for compiles, using them in a camera, 
media player, phone with a FAT filesystem will excersise the FAT blocks 
enough to cause problems

>>> That said, ext3's assumption that filesystem block size always >= disk
>>> update block size _is_ a fundamental part of this problem, and one that
>>> isn't shared by things like jffs2, and which things like btrfs might be
>>> able to address if they try, by adding awareness of the real media update
>>> granularity to their node layout algorithms.  (Heck, ext2 has a stripe
>>> size parameter already. Does setting that appropriately for your raid
>>> make this suck less?  I haven't heard anybody comment on that one yet...)
>>
>> I thought that that assumption was in the VFS layer, not in any particular
>> filesystem
>
> The VFS layer cares about how to talk to the backing store?  I thought that
> was the filesystem driver's job...

I could be mistaken, but I have run into cases with filesystems where the 
filesystem was designed to be able to use large blocks, but they could 
only be used on specific architectures because the disk block size had to 
be smaller than the page size.

> I wonder how jffs2 gets around it, then?  (Or for that matter, squashfs...)

if you know where the eraseblock boundries are, all you need to do is 
submit your writes in groups of blocks corresponding to those boundries. 
there is no need to make the blocks themselves the size of the 
eraseblocks.

any filesystem that is doing compressed storage is going to end up dealing 
with logical changes that span many different disk blocks.

I thought that squashfs was read-only (you create a filesystem image, burn 
it to flash, then use it)

as I say I could be completely misunderstanding this interaction.

David Lang
