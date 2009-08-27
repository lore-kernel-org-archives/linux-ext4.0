From: david@lang.hm
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Date: Wed, 26 Aug 2009 23:54:30 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.0908262342120.6822@asgard.lang.hm>
References: <4A92F6FC.4060907@redhat.com> <20090826111751.GC26595@elf.ucw.cz> <20090826122813.GI32712@mit.edu> <200908270106.15032.rob@landley.net>
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
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <200908270106.15032.rob@landley.net>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 27 Aug 2009, Rob Landley wrote:

> On Wednesday 26 August 2009 07:28:13 Theodore Tso wrote:
>> On Wed, Aug 26, 2009 at 01:17:52PM +0200, Pavel Machek wrote:
>>>> Metadata takes up such a small part of the disk that fscking
>>>> it and finding it to be OK is absolutely no guarantee that
>>>> the data on the filesystem has not been horribly mangled.
>>>>
>>>> Personally, what I care about is my data.
>>>>
>>>> The metadata is just a way to get to my data, while the data
>>>> is actually important.
>>>
>>> Personally, I care about metadata consistency, and ext3 documentation
>>> suggests that journal protects its integrity. Except that it does not
>>> on broken storage devices, and you still need to run fsck there.
>>
>> Caring about metadata consistency and not data is just weird, I'm
>> sorry.  I can't imagine anyone who actually *cares* about what they
>> have stored, whether it's digital photographs of child taking a first
>> step, or their thesis research, caring about more about the metadata
>> than the data.  Giving advice that pretends that most users have that
>> priority is Just Wrong.
>
> I thought the reason for that was that if your metadata is horked, further
> writes to the disk can trash unrelated existing data because it's lost track
> of what's allocated and what isn't.  So back when the assumption was "what's
> written stays written", then keeping the metadata sane was still darn
> important to prevent normal operation from overwriting unrelated existing
> data.
>
> Then Pavel notified us of a situation where interrupted writes to the disk can
> trash unrelated existing data _anyway_, because the flash block size on the 16
> gig flash key I bought retail at Fry's is 2 megabytes, and the filesystem thinks
> it's 4k or smaller.  It seems like what _broke_ was the assumption that the
> filesystem block size >= the disk block size, and nobody noticed for a while.
> (Except the people making jffs2 and friends, anyway.)
>
> Today we have cheap plentiful USB keys that act like hard drives, except that
> their write block size isn't remotely the same as hard drives', but they
> pretend it is, and then the block wear levelling algorithms fuzz things
> further.  (Gee, a drive controller lying about drive geometry, the scsi crowd
> should feel right at home.)

actually, you don't know if your USB key works that way or not. Pavel has 
ssome that do, that doesn't mean that all flash drives do

when you do a write to a flash drive you have to do the following items

1. allocate an empty eraseblock to put the data on

2. read the old eraseblock

3. merge the incoming write to the eraseblock

4. write the updated data to the flash

5. update the flash trnslation layer to point reads at the new location 
instead of the old location.

now if the flash drive does things in this order you will not loose any 
previously written data.

if the flash drive does step 5 before it does step 4, then you have a 
window where a crash can loose data (and no btrfs won't survive any better 
to have a large chunk of data just disappear)

it's possible that some super-cheap flash drives skip having a flash 
translation layer entirely, on those the process would be

1. read the old data into ram

2. merge the new write into the data in ram

3. erase the old data

4. write the new data

this obviously has a significant data loss window.

but if the device doesn't have a flash translation layer, then repeated 
writes to any one sector will kill the drive fairly quickly. (updates to 
the FAT would kill the sectors the FAT, journal, root directory, or 
superblock lives in due to the fact that every change to the disk requires 
an update to this file for example)

> Now Pavel's coming back with a second situation where RAID stripes (under
> certain circumstances) seem to have similar granularity issues, again breaking
> what seems to be the same assumption.  Big media use big chunks for data, and
> media is getting bigger.  It doesn't seem like this problem is going to
> diminish in future.
>
> I agree that it seems like a good idea to have BIG RED WARNING SIGNS about
> those kind of media and how _any_ journaling filesystem doesn't really help
> here.  So specifically documenting "These kinds of media lose unrelated random
> data if writes to them are interrupted, journaling filesystems can't help with
> this and may actually hide the problem, and even an fsck will only find
> corrupted metadata not lost file contents" seems kind of useful.

I think an update to the documentation is a good thing (especially after 
learning that a raid 6 array that has lost a single disk can still be 
corrupted during a powerfail situation), but I also agree that Pavel's 
wording is not detailed enough

> That said, ext3's assumption that filesystem block size always >= disk update
> block size _is_ a fundamental part of this problem, and one that isn't shared
> by things like jffs2, and which things like btrfs might be able to address if
> they try, by adding awareness of the real media update granularity to their
> node layout algorithms.  (Heck, ext2 has a stripe size parameter already.
> Does setting that appropriately for your raid make this suck less?  I haven't
> heard anybody comment on that one yet...)

I thought that that assumption was in the VFS layer, not in any particular 
filesystem


David Lang
