From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 18:26:33 -0500
Message-ID: <20121114232633.18292.qmail@science.horizon.com>
References: <20121114203942.GA23511@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:38426 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423527Ab2KNX0f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 18:26:35 -0500
In-Reply-To: <20121114203942.GA23511@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> If you don't mind, *my* primary question is "what can I salvage from
>> this rubble?", since I didn't happen to have 8 TB of backup space
>> available to me when I did the resize, and there's some stuff on the
>> FS I'd rather not lose...

> Sigh...  ok, unfortunately that's not something I can answer right
> away.  I *can* tell you what happened, though.  Figuring out the best
> way to help you recover while minimizing data loss is going to require
> more thought....

Well, I scanned BGs 0-15 (and a bit past) for anything that looked like
an inode block (and didn't find anything), or a directory block (and found
pretty much everything).

After talking to the owner of the machine, we decided to give up on
inodes 129-2048 and let e2fsck have at it, then and use the directory
information rename everything in lost+found back to the right names.

Unfortunately, that ended up with about 1.2 TB of data loss.  Some
is backups of other machines that can simply be re-backed-up, but most
is media that can be re-ripped.

There was an excellent chance of finding even large files written to
contiguous sectors, given that the FS was created immediately before
resize by "cp -a" from a 32bit file system, but it would take some
file-type-specific tools to see if a given sector range "looked like"
a correct file, and the *rest* of the FS would be inaccessible until
I got that working.

We decided that recovery sooner rather then more complete was better.


Fortunately, the important unreproducible files are mostly intact,
and what isn't there is mostly duplicated on people's laptops.

There are irreplaceable losses, but they're a very small fraction of
that 1.2 TB.  It's just going to be a PITA finding it all from scattered
sources.

> First of all, the support for 64-bit online-resizing didn't hit the
> 3.6 kernel, and since it's a new feature, it's unlikely the stable
> kernel gatekeepers will accept it unless and until at leastr one
> distribution who is using a stable kernel is willing to backport the
> patches to their distro kernel.  So in order to use it, you'll need a
> 3.7-rc1 or newer kernel.  That explains why the on-line resizing
> didn't work.

Ah, and I wasn't about to let an -rc kernel near this machine.

I keep reading docs and thinking features I want to use are more stable
than they are.

> The reason why you lost so badly when you did an off-line resize was
> because you explicitly changed the resize limit default, via the -E
> resize=NNN option.  (Can you explain to me your thinking about why you
> specified this, just out of curiosity?)

Because I figured there was *some* overhead, and the documented
preallocation of 1000x initial FS size was preposterously large.

I figured I'd explicitly set it to a reasonable value that was as large
as I could imagine the FS growing in future, and definitely large enough
for my planned resize.

Especially as I was informed (in the discussion when I reported the
"mke2fs -O 64bit -E resize=xxxx" bug) that it was actually *not* a hard
limit and resize2fs could move sectors to grow past that limit.

> Normally the default is 1000 times the size of the original file system,
> or for a file system larger than 16GB, enough so that the file system
> can be resized to the maximum amount that can be supported via the
> resize_inode scheme, which is 16TB.  In practice, for pretty much any
> large file system, including pretty much any raid arrays, the default
> allows us to do resizes without needing to move any inode table blocks.

Um, but on a 64bit file system, flex_bg *can* grow past 16 TB.

The limit is basically when BG#0 no longer has room for any data blocks,
and the fixed overhead runs into the backup superblock in block #32768.

With -i 1Mi and a flex_bg group size of 16, there are 1 + 16 * (1 +
1 + 8) = 161 blocks of other metadata (superblock, plus 16 x (block
bitmap + inode bitmap + inodes), leaving 32607 blocks available for
group descriptors.

At 4096/64 = 64 descriptors per block, that's 2086848 block groups,
260856 GiB = 254.7 TiB = 280 TB (decimal).


One source of the problem is that I asked for a 64 TiB grow limit
*and didn't get it*.  Even if mke2fs had done its math wrong and only
preallocated 32 * (64 TiB/128 MiB) = 16 MiB (4096 blocks) of GDT space,
I would have been fine.

If I had got the full 8192 blocks of preallocated GDT space that I asked
for, there definitely would not have been a problem.

It appears that it preallocated 1955 blocks of GDT space (enough for
15.27 TiB of array) and things went funny...

I tried resize=2^32 and 2^32-1 blocks when reporting the 64bit bug
to see if that affected the divide by 0, but even if I'd cut & pasted
those improperly, I should have had 2048 blocks of preallocateg GDT.

> Sigh.  Unfortunately, you fell into this corner case, which I failed
> to forsee and protect against.

And by a bug in mke2fs, which failed to allocate the resize space I
requested.  If it had computed the space correctly for the 64bit case,
there would have been enough and all this would have been avoided.


Of course, fixing the resizer to handle flex_bg probably isn't that hard.
Assuming standard layout, all the blocks of a given type are contiguous,
and the only difference between a flex_bg group and simply a larger
block group is the layout of the inode bitmaps.

Just treat it as a block group with (in this case) 128 pages of inodes,
8 pages of block bitmap, and 8 pages of inode bitmap, and bingo.

You just need to verify the preconditions first and set up the 16 GDT
entries to point to bits of it later.

> It is relatively easy to fix resize2fs so it detects this case and
> handles it appropriately.  What is harder is how to fix a file system
> which has been scrambed by resize2fs after the fact.  There will
> definitely be some parts of the inode table which will have gotten
> overwritten, because resize2fs doesn't handle the flex_bg layout
> correctly when moving inode table blocks.  The question is what's the
> best way of undoing the damage going forward, and that's going to have
> to require some more thought and probably some experimentation and
> development work.
> 
> If you don't need the information right away, I'd advise you to not
> touch the file system, since any attempt to try to fix is likely to
> make the problem worse (and will cause me to to have to try to
> replicate the attempted fix to see what happened as a result).  I'm
> guessing that you've already tried running e2fsck -fy, which aborted
> midway through the run?

I tried running e2fsck, which asked questions, and I hit ^C rather than
say anything.  Then I tried e2fsck -n, which aborted.

This afternoon, I ran e2fsck -y and did the reconstruction previously
described.  Without the inode block maps (which you imply got
overwritten), putting the files back together is very hard.

> P.S.  This doesn't exactly replicate what you did, but it's a simple
> repro case of the failure which you hit.  The key to triggering the
> failure is the specification of the -E resize=NNN option.  If you
> remove this, resize2fs will not corrupt the file system:
> 
> # lvcreate -L 32g -n bigscratch /dev/closure
> # mke2fs -t ext4 -E resize=12582912 /dev/closure/bigscratch
> # lvresize -L 64g /dev/closure/bigscratch
> # e2fsck -f /dev/closure/bigscratch
> # resize2fs -p /dev/closure/bigscratch
> # e2fsck -fy /dev/closure/bigscratch

Yeah, I see how that would cause problems, as you ask for 51.5G of
resize range.  What pisses me off is that I asked for 64 TiB!
(-E resize=17179869184)
