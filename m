From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Tue, 10 Jul 2007 22:12:14 -0600
Message-ID: <20070711041213.GH6417@schatzie.adilger.int>
References: <20070710112307.34c2ba5c@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:49945 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbXGKEMR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 00:12:17 -0400
Content-Disposition: inline
In-Reply-To: <20070710112307.34c2ba5c@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  11:23 -0500, Jose R. Santos wrote:
> I've started playing with the FLEX_BG feature (for now packing of
> block group metadata closer together) and started doing some
> preliminary benchmarking to see if the feature is worth pursuing.
> I chose an FFSB profile that does single threaded small creates and
> writes and then does an fsync.  This is something I ran for a customer
> a while ago in which ext3 performed poorly.

Jose,
thanks for the information and testing.  This is definitely very
interesting and shows this is an avenue we should pursue.

> Here are some of the results (in transactions/sec@%CPU util) on a single
> 143GB@10K rpm disk.
> 
> ext4				1680.54@2.9%
> ext4(flex_bg)			2105.56@3.7% 20% improvement
> ext4(data=writeback)		1374.50@2.0% <- hum...
> ext4(flex_bg data=writeback)	2323.12@3.7% 28% over best ext4
> ext3				1025.84@1.7%
> ext3(data=writeback)		1136.85@1.7%
> ext2				1152.59@0.9%
> xfs				1968.84@1.9%
> jfs				1424.05@1.2%
> 
> The results are from packing the metadata of 64 block groups closer
> together at fsck time.  Still need to clean up the e2fsprog patches,

Does this mean that you are just moving the bitmaps and inode table
at mke2fs time, or also such things as directory blocks at fsck time?

> but I hope to submit them to the list later this week for others to
> try.  It seems like fsck doesn't quite like the new location of the
> metadata and I'm not sure how big of an effort it will be to fix it.  I
> mentioned this since one of the assumptions of implementing FLEX_BG was
> the reduce time in fsck and it could be a while before I'm able to test
> this.

i think in the spirit of the original META_BG option, Ted had wanted to
put all the bitmaps from EXT4_DESC_PER_BLOCK groups somewhere within the
metagroup.  It would also be interesting to see if moving ALL of the
group metadata to a single location in the filesystem makes a bit difference.
If not, then we may as well keep it spread out for safety.

You might also want to test out placement of the journal in the middle
of the filesystem, the U. Wisconsin folks tested this in one of their
papers and showed some noticable improvements.  That isn't exactly
related, but it is a relatively simple tweak to mke2fs/tune2fs to give
it an allocation goal of group_desc[s_groups_count / 2].bg_inode_table
(to put it past inode table in middle group).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
