From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: #blocks per group too big: 37265
Date: Thu, 03 Apr 2008 12:58:30 -0500
Message-ID: <47F51AC6.6010205@redhat.com>
References: <20080403161904.GA31670@msgid.wurtel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbYDCR6c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 13:58:32 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m33HwVvT000679
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 13:58:32 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33HwVSj007161
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 13:58:31 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33HwUL4000396
	for <linux-ext4@vger.kernel.org>; Thu, 3 Apr 2008 13:58:31 -0400
In-Reply-To: <20080403161904.GA31670@msgid.wurtel.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Paul Slootman wrote:
> Hi,
> I wanted to try out ext4 on my shiny new 9+TB RAID5 device
> (11 x 1TB disks in md raid5).
> 
> I obtained the 1.39-tyt3 version of e2fsprogs, and did:
> 
> ./mkfs.ext3 -j -m 0 -N 1000000000 -O dir_index,filetype,resize_inode -E stride=65536,resize=5120000000 -J device=/dev/mapper/vg11-md15--journal -L data2 /dev/md15
> 
> (If using a separate device for the journal is inadvisable, please let
> me know; this is on a different set of spindles that md15 is running on.)
> 
> The stride was calculated from the 64k chunk of the raid5 device.
> Mainly a guess, as I couldn't find any clear reference on how to plug in
> the values to fill this in.
> 
> Anyway, that did:
> 
> | mke2fs 1.38 (30-Jun-2005)
> | Filesystem label=data2
> | OS type: Linux
> | Block size=4096 (log=2)
> | Fragment size=4096 (log=2)
> | 1000204128 inodes, 2441859680 blocks
> | 0 blocks (0.00%) reserved for the super user
> | First data block=0
> | Maximum filesystem blocks=5485408000
> | 65527 block groups
> | 37265 blocks per group, 37265 fragments per group

I'd probably not use 1.39-tyt3... that's pretty old.  (see the 2005?) :)

I did some >8T work that didn't officially make it in 'til 1.40... I'm
not sure if it's in 1.39-tyt3 or not, I'd guess not.

Also, stride=65536 isn't going to give you what you want, at a minimum
because it's stored in a __u16, and it'll wrap around to 0.  (newer
e2fsprogs fails this way, though it's not clear that that's the reason,
when it fails).

But, if I try bleeding edge e2fsprogs on a semi-similar fs (smaller
stride value just so it doesn't fail):

[tmp]$ /src2/e2fsprogs-git/e2fsprogs/misc/mke2fs -F -j -m 0 -N
1000000000 -O dir_index,filetype,resize_inode -E
stride=13172,resize=5120000000 -J device=journal  -L data2 testfsfile
mke2fs 1.40.8 (13-Mar-2008)
Filesystem label=data2
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
1001548800 inodes, 2441859680 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
74520 block groups
32768 blocks per group, 32768 fragments per group
13440 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
	102400000, 214990848, 512000000, 550731776, 644972544, 1934917632


I at least get a sane blocks per group.

-Eric
