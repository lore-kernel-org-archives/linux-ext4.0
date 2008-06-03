From: Thomas King <kingttx@tomslinux.homelinux.org>
Subject: Re: Questions for article
Date: Tue, 3 Jun 2008 10:10:33 -0500 (CDT)
Message-ID: <61365.143.166.255.40.1212505833.squirrel@tomslinux.homelinux.org>
References: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org>
    <20080602225942.GQ2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38622 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFCPZw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 11:25:52 -0400
Received: from tomslinux.homelinux.org ([24.28.24.180])
          by hrndva-omta05.mail.rr.com with ESMTP
          id <20080603151044.SWJD12416.hrndva-omta05.mail.rr.com@tomslinux.homelinux.org>
          for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 15:10:44 +0000
Received: from tomslinux.homelinux.org (localhost [127.0.0.1])
	by tomslinux.homelinux.org (8.13.7/8.13.7) with ESMTP id m53FAYmM026444
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 10:10:34 -0500
In-Reply-To: <20080602225942.GQ2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Jun 02, 2008  16:50 -0500, Thomas King wrote:
>> I am writing an article for Linux.com to answer Henry Newman's at
>> http://www.enterprisestorageforum.com/sans/features/article.php/3749926. Is
>> there anyone that can field a few questions on ext4?
>
> It depends on what you are proposing to write...  Henry's comments are
> mostly accurate.  There isn't even support for > 16TB filesystems in
> e2fsprogs today, so I wouldn't go rushing into an email saying "ext4
> can support a single 100TB filesystem today".  It wouldn't be too hard
> to take a 100TB Lustre filesystem and run it on a single node, but I
> doubt anyone would actually want to do that and it still doesn't meet
> the requirements of "a single instance filesystem".
>
Aye, as you probably saw in his article, he's skirting cluster filesystems since
most of the implementations he's referencing use a single physical filesystem.

> What is noteworthy is that the comments about IO not being aligned
> to RAID boundaries is only partly correct.  This is actually done in
> ext4 with mballoc (assuming you set these boundaries in the superblock
> manually), and is also done by XFS automatically.  The RAID geometry
> detection code should be added to mke2fs also, if someone would be
> interested.  The ext4/mballoc code does NOT align the metadata to RAID
> boundaries, though this is being worked on also.
>
Good to know!

> The mballoc code also does efficient block allocations (multi-MB at a
> time), BUT there is no userspace interface for this yet, except O_DIRECT.
> The delayed allocation (delalloc) patches for ext4 are still in the unstable
> part of the patch series...  What Henry is misunderstanding here is that
> the filesystem blocksize isn't necessarily the maximum unit for space
> allocation.  I agree we could do this more efficiently (e.g. allocate an
> entire 128MB block group at a time for large files), but we haven't gotten
> there yet.
>
Can I assume this (large block size) is a possibility later?

> There are a large number of IO performance improvements in ext4 due to
> work to improve IO server performance for Lustre (which Henry is of
> course familiar with), and for Lustre at least we are able to get IO
> performance in the 2GB/s range on 42 50MB/s disks with software RAID 0
> (Sun x4500), but these are with O_DIRECT.
>
> For the fsck front, there have been performance improvements recently
> (uninit_bg), and more arriving soon (flex_bg and block metadata
> clustering), but that is still a far way from removing the need for
> e2fsck in case of corruption.
>
> Similarly, Lustre (with ext3) can scale to a 10M file directory reasonably
> (though not superbly) for a certain kind of workload.  On the other hand,
> this can be really nasty with a "readdir+stat" kind of workload.  Lustre
> also runs with filesystems > 250M files total, but I haven't heard of
> e2fsck performance for such filesystems.
>
>
> I'd personally tend to keep quiet until we CAN show that ext4
> runs well on a 100TB filesystem, that e2fsck time isn't fatal, etc.
>
What will be the largest theoretical filesystem for ext4?
Here are three other features he thought necessary for massive filesystems in
Linux:
-T10 DIF (block protect?) aware file system
-NFSv4.1 support
-Support for proposed POSIX relaxation extensions for HPC
Are these already in ext4 or on the radar?
Is there anything else y'all would like folks to know about ext4 and its future?

>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.

Thanks!
Tom King
