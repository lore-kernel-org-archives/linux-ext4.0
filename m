From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: merging of two file system
Date: Thu, 07 Aug 2008 14:33:20 +0200
Message-ID: <87y73957jj.fsf@frosties.localdomain>
References: <425904320807270905k32264faaq5c813b73000ee5c6@mail.gmail.com>
	<20080727225246.GD7922@mit.edu>
	<5feb302e0807281147y7362a227kb7d37d713be05296@mail.gmail.com>
	<425904320807281211y517f8847rc93cfa6a3a13aac3@mail.gmail.com>
	<20080728200439.GL9378@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vineet Agarwal <checkout.vineet@gmail.com>,
	rishi agrawal <postrishi@gmail.com>,
	linux-ext4@vger.kernel.org, listar@nl.linux.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:43472 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888AbYHGMdX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 08:33:23 -0400
In-Reply-To: <20080728200439.GL9378@mit.edu> (Theodore Tso's message of "Mon,
	28 Jul 2008 16:04:39 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Jul 29, 2008 at 12:41:25AM +0530, Vineet Agarwal wrote:
>> yeah i meant that we have to separate filesystems,
>> stored for example on /dev/hda1 and /dev/hda2, and we want to combine
>> the data in the two filesystems into a single filesystem /dev/hda3, or
>> combining the contents of /dev/hda2 so that it is also in /dev/hda1
>> 
>> so is there any mechanism exist to do so either online or offline . please help
>
> There is no direct way to do this.
>
> How big are the filesystems involved?  The standard and easist way to
> do this would be to copy /dev/hda2 to another device, then if
> /dev/hda1 was created with on-line resizing inode, expanding /dev/hda1
> to fill the space taken by /dev/hda2, and then simply use "cp" to copy
> the contents that had previously been in /dev/hda2 into the filesystem
> on /dev/hda1.

Or if you have no extra disk but some free space you can copy as much
as possible to hda1, shrink hda2, move hda2, grow hda1, repeat.

At which point you really start to wish you had used LVM in the first
place.

> In theory it would be possible to write a program would take to
> adjacent filesystems, and map out where the blocks would be once the
> two partitions were combined, and then relocate blocks to make a
> single filesystem.  No one has done such a thing, however, for any
> filesytem.  It is definitely not a trivial thing to do, but it is not
> impossible; it's not that different from some of what an off-line
> resize2fs operations does, albeit maybe 3-4 times more complex.
>
> The main thing is that no one has ever taken the time to do such a
> thing, because except for truly large filesystems, it's cheaper just
> to get an extra disk drive, and just copy the contents off, and then
> recreate the filesystem.

I've started such a thing. Not specifically for merging 2 filesystem
but for changing from one filesystem to another. Actually I did it
even more generic by attacking the problem at the block devie layer.
The method was this:

1) Convert the physical block device into a sparse device
   - Copy the first few blocks to a safe place
   - Map the first few blocks to the safe place and the rest to the
     physical device
   - Fill the old filesystem with zero (this frees the blocks from the
     mapping and creates empty space)
2) Create a 2nd sparse device (fully empty)
3) successivley move files from old to new and write more zeroes to
   old (this allocates free blocks to the 2nd device as data gets
   written and frees blocks from the 1st devcie as zeroes are written)
4) Destroy empty 1st device
5) Convert sparse 2nd device to physical
   - Move first few virtual blocks to safe place
   - Defragment all other blocks so virtual == physical
   - move blocks from safe palce to physical overwriting the sparse
     device metadata

The safe palce is used as extra storage when the physical device has
not enough blocks and to store recovery state infos. With enough free
space on the FS only a few MB are needed.


I used this to convert from xfs to ext3 but then run into a bug during
defragmenting and had to restore from backup. As I used ext3 to
restore to I had no need for this anymore so I never finished it.

MfG
        Goswin
