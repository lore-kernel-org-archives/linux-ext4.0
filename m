From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Missing JBD2_FEATURE_INCOMPAT_64BIT in ext4
Date: Thu, 19 Apr 2007 15:18:17 -0600
Message-ID: <20070419211817.GO5967@schatzie.adilger.int>
References: <20070415161606.GG5967@schatzie.adilger.int> <1177010100.6703.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:44661 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667AbXDSVSU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 17:18:20 -0400
Content-Disposition: inline
In-Reply-To: <1177010100.6703.8.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 19, 2007  12:15 -0700, Mingming Cao wrote:
> On Sun, 2007-04-15 at 10:16 -0600, Andreas Dilger wrote:
> > Just a quick note before I forget.  I thought there was a call in ext4
> > to set JBD2_FEATURE_INCOMPAT_64BIT at mount time if the filesystem has
> > more than 2^32 blocks?
> 
> Question about the online resize case. If the fs is increased to more
> than 2^32 blocks, we should set this JBD2_FEATURE_INCOMPAT_64BIT in the
> journal. What about existing transactions that still stores 32 bit block
> numbers?  I guess the journal need to commit them all so that revoke
> will not get confused about the bits for block numbers later.  After
> that done then JBD2 can set this feature safely.

Well, there are two options here:
1) refuse resizing filesystems beyond 16TB
   - this is required if they were not formatted as ext4 to start with, as
     the group descriptors will not be large enough to handle the "_hi"
     word in the bitmap/inode table locations
   - this is also a problem for block-mapped files that need to allocate
     blocks beyond 16TB (though this could just fail on those files with
     e.g. ENOSPC or EFBIG or something similar)
2) flush the journal (like ext4_write_super_lockfs()) while resizing beyond
   16TB.  This would also require changing over to META_BG at some point,
   because there cannot be enough reserved group descriptor blocks (the
   resize_inode is set up for a maximum of 2TB filesystems I think)
   
For now I'd be happy with just setting the JBD2_*_64BIT flag at mount for
filesystems > 16TB, and refusing resize across 16TB.  We can fix it later.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
