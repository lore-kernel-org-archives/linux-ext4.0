From: Andreas Dilger <adilger@sun.com>
Subject: Re: Questions for article
Date: Mon, 02 Jun 2008 16:59:42 -0600
Message-ID: <20080602225942.GQ2961@webber.adilger.int>
References: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:44733 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbYFBW7p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 18:59:45 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m52Mxil1025277
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jun 2008 15:59:45 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1U00601YEB6H00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 02 Jun 2008 15:59:44 -0700 (PDT)
In-reply-to: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 02, 2008  16:50 -0500, Thomas King wrote:
> I am writing an article for Linux.com to answer Henry Newman's at
> http://www.enterprisestorageforum.com/sans/features/article.php/3749926. Is
> there anyone that can field a few questions on ext4?

It depends on what you are proposing to write...  Henry's comments are
mostly accurate.  There isn't even support for > 16TB filesystems in
e2fsprogs today, so I wouldn't go rushing into an email saying "ext4
can support a single 100TB filesystem today".  It wouldn't be too hard
to take a 100TB Lustre filesystem and run it on a single node, but I
doubt anyone would actually want to do that and it still doesn't meet
the requirements of "a single instance filesystem".

What is noteworthy is that the comments about IO not being aligned
to RAID boundaries is only partly correct.  This is actually done in
ext4 with mballoc (assuming you set these boundaries in the superblock
manually), and is also done by XFS automatically.  The RAID geometry
detection code should be added to mke2fs also, if someone would be
interested.  The ext4/mballoc code does NOT align the metadata to RAID
boundaries, though this is being worked on also.

The mballoc code also does efficient block allocations (multi-MB at a
time), BUT there is no userspace interface for this yet, except O_DIRECT.
The delayed allocation (delalloc) patches for ext4 are still in the unstable
part of the patch series...  What Henry is misunderstanding here is that
the filesystem blocksize isn't necessarily the maximum unit for space
allocation.  I agree we could do this more efficiently (e.g. allocate an
entire 128MB block group at a time for large files), but we haven't gotten
there yet.

There are a large number of IO performance improvements in ext4 due to
work to improve IO server performance for Lustre (which Henry is of
course familiar with), and for Lustre at least we are able to get IO
performance in the 2GB/s range on 42 50MB/s disks with software RAID 0
(Sun x4500), but these are with O_DIRECT.

For the fsck front, there have been performance improvements recently
(uninit_bg), and more arriving soon (flex_bg and block metadata
clustering), but that is still a far way from removing the need for
e2fsck in case of corruption.

Similarly, Lustre (with ext3) can scale to a 10M file directory reasonably
(though not superbly) for a certain kind of workload.  On the other hand,
this can be really nasty with a "readdir+stat" kind of workload.  Lustre
also runs with filesystems > 250M files total, but I haven't heard of
e2fsck performance for such filesystems.


I'd personally tend to keep quiet until we CAN show that ext4
runs well on a 100TB filesystem, that e2fsck time isn't fatal, etc.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

