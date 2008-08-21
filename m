From: Andreas Dilger <adilger@sun.com>
Subject: Re: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 19:44:07 -0600
Message-ID: <20080821014407.GS3392@webber.adilger.int>
References: <20080820054339.GB6381@skywalker>
 <20080820104644.GA11267@skywalker> <20080820115331.GA9965@mit.edu>
 <1219265808.7895.14.camel@mingming-laptop>
 <1219274535.7895.55.camel@mingming-laptop>
 <20080820234208.GO3392@webber.adilger.int>
 <1219276727.7895.69.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36081 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbYHUBoa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 21:44:30 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7L1iRJG006552
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 18:44:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K5X00601GOHA800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 20 Aug 2008 18:44:27 -0700 (PDT)
In-reply-to: <1219276727.7895.69.camel@mingming-laptop>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 20, 2008  16:58 -0700, Mingming Cao wrote:
> > Also, if you are doing this by changing the aops on the inode, isn't
> > it possible that a large write starts outside the EXT4_MIN_FREE_BLOCKS
> > boundary and then still runs out of space without changing the aops?
> 
> > Instead it is maybe better to do the check at the start of
> > ext4_da_write_begin() and if it fails then call the non-delalloc
> > write_begin from there?
> 
> Yeah that's better.
> 
> But I realize  a problem. Actually now I think we can't fall back to
> nondelalloc mode if the inode has any dirty pages in the page cache, as
> those pages need delalloc aops ->ext4_da_writepages() to handle delayed
> allocation writeout..

That is only if you are changing the aops, which I already don't think
is a good idea.  Instead, as I suggest there should be a check in the
ext4_da_write_begin() that makes the decision to delay the allocation
or to actually do it, based on the current free blocks.

Instead of doing this check repeatedly (if we think it is expensive, maybe
it isn't), it might make sense to set a superblock flag that indicates
"no more delalloc, too close to ENOSPC" and this is cleared when blocks
are freed beyond the low watermark.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

