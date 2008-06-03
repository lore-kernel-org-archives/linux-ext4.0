From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Questions for article
Date: Mon, 02 Jun 2008 19:40:44 -0500
Message-ID: <4844930C.8010503@redhat.com>
References: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org> <20080602225942.GQ2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Thomas King <kingttx@tomslinux.homelinux.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYFCAk6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jun 2008 20:40:58 -0400
In-Reply-To: <20080602225942.GQ2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jun 02, 2008  16:50 -0500, Thomas King wrote:
>> I am writing an article for Linux.com to answer Henry Newman's at
>> http://www.enterprisestorageforum.com/sans/features/article.php/3749926. Is
>> there anyone that can field a few questions on ext4?
> 
> It depends on what you are proposing to write...  Henry's comments are
> mostly accurate.  

But others are way off base IMHO, to the point where I don't put a lot
of stock in the article.  fsck only checks the log?  Hardly.  No linux
filesystem does proper geometry alignment?  XFS has for years.

He seems to take ext3 weaknesses and extrapolate to all linux
filesystems.   The fact that he suggests testing a 500T ext3 filesystem
indicates a ... lack of research.  Never mind that had he done that
research he'd have found that you, well... you can't do it.  :)  On the
one hand it proves his point about scalibility (of ext3) but on the
other hand indicates that he's not completely investigated the problem
of linux filesystem scalability, himself.

Of the tests he proposes, he's clearly not bothered to do them himself.
 A 100 million inode filesystem is not that uncommon on xfs, and some of
the tests he proposes are probably in daily use at SGI customers.

So writing an article about ext4 to refute all his arguments might be
premature, but dismissing all linux filesystems based on ext3
shortcomings is also shortsighted.  He has some valid points but saying
"fscking a multi-terabyte fs is too slow on linux" without showing that
it actually *is* slow on linux, or that it *is* fast on $whatever_else,
is just hand-waving.  On the other hand  it's a very hard test for mere
mortals to run.  :)

-Eric

> There isn't even support for > 16TB filesystems in
> e2fsprogs today, so I wouldn't go rushing into an email saying "ext4
> can support a single 100TB filesystem today".  It wouldn't be too hard
> to take a 100TB Lustre filesystem and run it on a single node, but I
> doubt anyone would actually want to do that and it still doesn't meet
> the requirements of "a single instance filesystem".
> 
> What is noteworthy is that the comments about IO not being aligned
> to RAID boundaries is only partly correct.  This is actually done in
> ext4 with mballoc (assuming you set these boundaries in the superblock
> manually), and is also done by XFS automatically.  The RAID geometry
> detection code should be added to mke2fs also, if someone would be
> interested.  The ext4/mballoc code does NOT align the metadata to RAID
> boundaries, though this is being worked on also.
> 
> The mballoc code also does efficient block allocations (multi-MB at a
> time), BUT there is no userspace interface for this yet, except O_DIRECT.
> The delayed allocation (delalloc) patches for ext4 are still in the unstable
> part of the patch series...  What Henry is misunderstanding here is that
> the filesystem blocksize isn't necessarily the maximum unit for space
> allocation.  I agree we could do this more efficiently (e.g. allocate an
> entire 128MB block group at a time for large files), but we haven't gotten
> there yet.
> 
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
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

