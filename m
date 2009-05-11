From: Andreas Dilger <adilger@sun.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 13:22:14 -0600
Message-ID: <20090511192214.GC3209@webber.adilger.int>
References: <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org>
 <20090511112729.GD29082@mit.edu> <20090511120936.GB6277@mit.edu>
 <87f94c370905110610j2f5ea7fcua4e596b2b5e82a5f@mail.gmail.com>
 <20090511142740.GC6277@mit.edu> <4A08365F.5040805@redhat.com>
 <20090511145059.GD6277@mit.edu> <20090511150040.GF8112@parisc-linux.org>
 <87f94c370905111147t77250b92pc511ef9c6c0e7e42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	J?rn Engel <joern@logfs.org>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux RAID <linux-raid@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35562 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZEKTXB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 15:23:01 -0400
Content-disposition: inline
In-reply-to: <87f94c370905111147t77250b92pc511ef9c6c0e7e42@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 11, 2009  14:47 -0400, Greg Freemyer wrote:
> Overall, I think Linux will need a mechanism to scan a filesystem and
> re-issue all the trim commands in order to get the hardware back in
> sync a major maintenance activity.  That mechanism could either be
> admin invoked.or a always on maintenance task.
> 
> Personally, I think the best option is a background task (kernel I
> assume) to scan the filesystem and issue discards for all the data on
> a slow but steady basis.  If it takes a week to make its way around
> the disk/volume, then it takes a week.  Who really cares.

I'd suggested that we can also modify e2fsck to (optionally) send the
definitive list of blocks to be trimmed at that time.  It shouldn't
necessarily be done all of the times e2fsck is run, because that would
kill any chance of data recovery, but should be optional.

Other filesystem checking tools (say btrfs online check) can periodically
do the same - lock an idle group from new allocations, scan the allocation
bitmap for all unused blocks, send a trim command for any regions >=
erase block size, unlock group.  It might make more sense to do this
than send thousands of trim operations while the filesystem is busy.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

