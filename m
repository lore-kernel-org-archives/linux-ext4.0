From: TR Reardon <thomas_reardon@hotmail.com>
Subject: RE: Reserved GDT inode: blocks vs extents
Date: Fri, 19 Sep 2014 13:26:38 -0400
Message-ID: <BAY179-W495E3AE101B78A7CAA43BAFDB40@phx.gbl>
References: <BAY406-EAS150EB9E4098E2894ADA30B7FDB40@phx.gbl>,<20140919163649.GQ26995@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc3s3.hotmail.com ([65.54.190.141]:55175 "EHLO
	BAY004-OMC3S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbaISR0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2014 13:26:39 -0400
In-Reply-To: <20140919163649.GQ26995@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Date: Fri, 19 Sep 2014 12:36:49 -0400
> From: tytso@mit.edu
> To: thomas_reardon@hotmail.com
> CC: linux-ext4@vger.kernel.org
> Subject: Re: Reserved GDT inode: blocks vs extents
>
> On Fri, Sep 19, 2014 at 11:54:39AM -0400, TR Reardon wrote:
>> Hello all: there's probably a good reason for this, but I'm wonderin=
g why inode#7 (reserved GDT blocks) is always created with a block map =
rather than extent?
>>
>> [see ext2fs_create_resize_inode()]
>
> It's created using an indirect map because the on-line resizing code
> in the kernel relies on it. It's rather dependent on the structure of
> the indirect block map so that the kernel knows where to fetch the
> necessary blocks in each block group to extend the block group
> descriptor.
>
> So no, we can't change it.
>
> And we do have a solution, namely the meta_bg layout which mostly
> solves the problem, although at the cost of slowing down the mount
> time.
>
> But that may be moot, since one of the things that I've been
> considering is to stop pinning the block group descriptors in memory,
> and just start reading in memory as they are needed. The rationale is
> that for a 4TB disk, we're burning 8 MB of memory. And if you have
> two dozen disks attached to your system, then you're burning 192
> megabytes of memory, which starts to fairly significant amounts of
> memory, especially for bookcase NAS servers.

But I'd argue that in many use cases, in particular bookcase NAS server=
s,=A0
ext4+vfs should optimize for avoiding spinups rather than reducing RAM =
usage.=A0
Would this change increase spinups when scanning for changes, say via r=
sync?
=46or mostly-cold-storage I wish I had the ability to make dentry- and =
inode-cache=A0
long lived, and have ext4 prefer to retain directory over file-data cac=
he blocks,=A0
rather than current non-deterministic behavior via vfs_cache_pressure. =
=A0Unfortunately,=A0
it is precisely the kinds of largefiles on bookcase NAS servers being r=
ead linearly=A0
(and used only once) that blowout the cache of directory blocks (and de=
ntries etc
but it's really the dir blocks that create the problem with spinups on =
cold-storage)

Of course, it's likelier that I don't actually understand how all these=
 caches work ;)

+Reardon


 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
