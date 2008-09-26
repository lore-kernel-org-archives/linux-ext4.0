From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] dynamic inodes
Date: Fri, 26 Sep 2008 04:36:07 -0600
Message-ID: <20080926103607.GB10950@webber.adilger.int>
References: <48DA28B0.2020207@sun.com>
 <20080925223731.GM10950@webber.adilger.int> <20080925201039.454bf742@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65318 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYIZKge (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 06:36:34 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8QAaTGd004905
	for <linux-ext4@vger.kernel.org>; Fri, 26 Sep 2008 03:36:29 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7S00001TBSNK00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 26 Sep 2008 03:36:29 -0700 (PDT)
In-reply-to: <20080925201039.454bf742@gara>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 25, 2008  20:10 -0500, Jose R. Santos wrote:
> One way to get around this is to implement the exact opposite of what I
> proposed earlier and have a block group with no inode tables.  If we do
> a 1:1 distribution of inode per block and don't allocate inodes tables
> for a series of block groups within a flexbg we could later on attempt
> to allocate new inode tables when we run out of inodes.  If we leave
> holes in the inode numbers for the missing inode tables, adding new
> inode tables in these block groups would not require any inode
> renumbering.  This also does not break the current inode allocator
> which would be a good thing.  This should be even simpler to implement
> than the previous proposal.  The drawbacks are that when allocating a
> new inode table, the 1:1 distribution of inode per block would mean
> that we need to find a bigger chunk on contiguous blocks to since we
> have bigger inode tables per block group.  Since the current inode
> allocator tries to keep a 10% of blocks in a flexbg free, finding
> contiguous blocks may not be a really big issue.  Another issue is 64bit
> filesystem if we use a 1:1 scheme.
> 
> This would be like uninitialized inode tables with the added steps of
> finding free blocks, allocating a new inode and zeroing the newly
> created inode table.  Since we could chose to allocate a new inode
> table on a flexbg with the most free blocks, this could keep filesystem
> meta-data/data layout consistently close together to maintain
> predictable performance.  This option also has no overhead compared to
> the previous proposal.

The problem with leaving gaps in the itable is that this needs the
filesystem to be created in this manner in the first place, while adding
them at the end can be done to any filesystem.  If we are preparing the
filesystem in advance for this we could just reserve enough GDT space
too (as online resize already does to some extent)..

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

