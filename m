From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Wed, 11 Jul 2007 00:30:04 -0500
Message-ID: <20070711003004.531c9307@naruto>
References: <20070710112307.34c2ba5c@rx8>
	<20070711041213.GH6417@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52919 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114AbXGKFaN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 01:30:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6B5UDL3029328
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 01:30:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6B5UCUZ244164
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 23:30:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6B5UCxt029613
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 23:30:12 -0600
In-Reply-To: <20070711041213.GH6417@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 10 Jul 2007 22:12:14 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jul 10, 2007  11:23 -0500, Jose R. Santos wrote:
> > I've started playing with the FLEX_BG feature (for now packing of
> > block group metadata closer together) and started doing some
> > preliminary benchmarking to see if the feature is worth pursuing.
> > I chose an FFSB profile that does single threaded small creates and
> > writes and then does an fsync.  This is something I ran for a customer
> > a while ago in which ext3 performed poorly.
> 
> Jose,
> thanks for the information and testing.  This is definitely very
> interesting and shows this is an avenue we should pursue.
> 
> > Here are some of the results (in transactions/sec@%CPU util) on a single
> > 143GB@10K rpm disk.
> > 
> > ext4				1680.54@2.9%
> > ext4(flex_bg)			2105.56@3.7% 20% improvement
> > ext4(data=writeback)		1374.50@2.0% <- hum...
> > ext4(flex_bg data=writeback)	2323.12@3.7% 28% over best ext4
> > ext3				1025.84@1.7%
> > ext3(data=writeback)		1136.85@1.7%
> > ext2				1152.59@0.9%
> > xfs				1968.84@1.9%
> > jfs				1424.05@1.2%
> > 
> > The results are from packing the metadata of 64 block groups closer
> > together at fsck time.  Still need to clean up the e2fsprog patches,
> 
> Does this mean that you are just moving the bitmaps and inode table
> at mke2fs time, or also such things as directory blocks at fsck time?

Right now what I've done is allocate the bitmaps and inode tables at the
beginning of each group of 64 BG.  Still need to work on fsck since just
removing the restriction on were the bitmaps and inode table are
located still gives me errors of uninitialized inodes with dtime set.
Seems like fsck still expect inode information to be located at
specific locations within the disk.

> > but I hope to submit them to the list later this week for others to
> > try.  It seems like fsck doesn't quite like the new location of the
> > metadata and I'm not sure how big of an effort it will be to fix it.  I
> > mentioned this since one of the assumptions of implementing FLEX_BG was
> > the reduce time in fsck and it could be a while before I'm able to test
> > this.
> 
> i think in the spirit of the original META_BG option, Ted had wanted to
> put all the bitmaps from EXT4_DESC_PER_BLOCK groups somewhere within the
> metagroup.  It would also be interesting to see if moving ALL of the
> group metadata to a single location in the filesystem makes a bit difference.
> If not, then we may as well keep it spread out for safety.

This is by no means a final implementation, rather it's a means to
test whether this feature is worth pursuing.  I plan on testing various
thing before coming up with a final design of what the feature should
look like.

I did try moving all of the groups metadata at the beginning of the
disk but it was slightly slower on an rsync test.  Have not tried it
with FFSB yet.

Things on the TODO list of testing needed to be done are:

- More metadata intensive FFSB profile testing.  I've been meaning to
add more operations to FFSB in order to make this possible.  Now I have
an excuse.

- Testing of different ratios of groups per flex groups.

- Testing with storage devices with fast write cache.  When I did the
customer testing a couple of months ago with this FFSB profile, JFS was
the fastest of the filesystems when paired with a decent storage
subsystem with fast write cache.  It would be interesting to see what
effects do fast write caching have on such a feature.

- Testing fsck time once e2fsprogs understands how to read such a
filesystem.

- Testing an aged file systems to see what effects (if any) this
feature has in a fragmented filesystem.

 
> You might also want to test out placement of the journal in the middle
> of the filesystem, the U. Wisconsin folks tested this in one of their
> papers and showed some noticable improvements.  That isn't exactly
> related, but it is a relatively simple tweak to mke2fs/tune2fs to give
> it an allocation goal of group_desc[s_groups_count / 2].bg_inode_table
> (to put it past inode table in middle group).

Make sense.  Do you have a link to the paper?

> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

Thanks

-JRS
