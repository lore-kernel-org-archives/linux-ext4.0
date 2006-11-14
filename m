From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2 readdir/lookup/check_page behavior
Date: Tue, 14 Nov 2006 13:44:25 -0700
Message-ID: <20061114204425.GT6012@schatzie.adilger.int>
References: <4559DFDF.30504@redhat.com> <20061114192102.GR6012@schatzie.adilger.int> <455A1B1C.4070705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59296 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S966347AbWKNUo1
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Nov 2006 15:44:27 -0500
To: Eric Sandeen <sandeen@redhat.com>
Content-Disposition: inline
In-Reply-To: <455A1B1C.4070705@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 14, 2006  13:38 -0600, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > It would make sense to fix ext2 in the same way.
> > I'd suggest bailing out "early" == min(i_size >> blocksize, i_blocks).
> > The i_blocks count is an upper limit, because it includes the overhead of
> > indirect blocks.  Directories cannot be sparse.
> 
> so we could either a) keep processing pages based on i_size, until we
> have passed i_blocks, or b) if i_size & i_blocks don't match,
> immediately bail out because we know we have found a corrupted inode
> (vs. a "normal" unreadable block...)

Do we already ext3_error() in this case?  That allows the admin to determine
the behaviour already.  If it is errors=continue or errors=remount-ro then
we should continue I think.  We might consider the inode fatally corrupted

	if (i_blocks << 9 < i_size ||
	    i_blocks > i_size >> (blockbits - 8) + /* blocks */
	    i_size >> (blockbits * 2 - 8 - 2) + /* indirect */
	    i_size >> (blockbits * 3 - 8 - 2) + /* dindirect */
	    i_size >> (blockbits * 4 - 8 - 2))  /* tindirect */

I think... Trying to account for indirect blocks.  It is already given a
100% margin (-8 instead of -9) to cover rounding, EA blocks, some small
bugs in block counting, extents format, etc.  FYI, the "-2" is 4 bytes/addr.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
