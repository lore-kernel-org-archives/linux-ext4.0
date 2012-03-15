From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Status of META_BG?
Date: Thu, 15 Mar 2012 15:06:59 -0600
Message-ID: <0A38CCE3-2F78-4B0E-9D5E-6C261EA61902@dilger.ca>
References: <4F620EDA.8030701@ubuntu.com> <20D13AAA-070A-4EE4-AC97-B553DC916228@dilger.ca> <4F622D18.3020805@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34843 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2COVGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Mar 2012 17:06:33 -0400
In-Reply-To: <4F622D18.3020805@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-15, at 11:55 AM, Phillip Susi wrote:
> On 3/15/2012 12:25 PM, Andreas Dilger wrote:
>> In the case of very large filesystems (256TB or more, assuming 4kB
>> block size) the group descriptor blocks will grow to fill an entire
>> block group, and in the case of group 0 and group 1 they would start
>> overlapping, which would not work.
> 
> To get an fs that large, you have to enable 64bit support, which also means you can pass the limit of 32k blocks per group.

I'm not sure what you mean here.  Sure, there can be more than 32k
blocks per group, but there is still only a single block bitmap per
group so having more blocks is dependent on a larger blocksize.

>  Doing that should allow for a much more reasonable number of groups ( which is a good thing several reasons ), and would also solve this problem wouldn't it?

Possibly in conjunction with BIGALLOC.

>> META_BG addresses both of these issues by distributing the group
>> descriptor blocks into the filesystem for each "meta group" (= the
>> number of groups whose descriptors fit into a single block).
> 
> So it puts one GD block at the start of every several block groups?

One at the start of the first group, the second group, and the last
group.

>  Wouldn't that drastically slow down opening/mounting the fs since the disk has to seek to every block group?

Yes, definitely.  That wasn't a concern before flex_bg arrived, since
that seek was needed for every group's block/inode bitmap as well.

> Perhaps if it were coupled with flex_bg so that flex_factor GD blocks would be clustered that would mitigate that somewhat, but iirc the default flex factor is only 16 so that might need bumped up for such large disks.

Something like this to work with flex_bg, but it would likely mean
an incompat change, since GD blocks are one of the few "absolute
position" blocks in the filesystem that allow finding all of the
other metadata.

Maybe with bigalloc the number of groups is reduced, and the size
of the groups is increased, which helps two ways.  First, fewer
groups means fewer GD blocks, and larger groups mean more GD blocks
can fit into the 0th and 1st groups.

>> The number of backups is reduced (0 - 3 backups), and the blocks do
>> not need to be contiguous anymore.
> 
> You know, I've been wondering why the group descriptors are backed up in the first place.  If the backups are only ever written at mkfs time, and can be reconstructed with mke2fs -S, then what purpose do they serve?

Well, the "mke2fs -S" is only applying a best guess estimate of the
metadata location using default parameters.  If the default parameters
are not identical (e.g. flex_bg on/off, bigalloc on/off, etc) then
"mke2fs -S" will only corrupt an already-fatally-corrupted filesystem,
and you need to start from scratch.

Having the group descriptor backups and superblocks in well-known
locations avoids this in most cases.  This makes me wonder whether
the backup superblock/GD for a bigalloc filesystem can even be
located without knowing the bigalloc cluster size, and whether e2fsck
will try a range of power-of-two cluster sizes to try and find it?

Cheers, Andreas





