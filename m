From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] fiemap support for ext3
Date: Mon, 21 Apr 2008 20:33:15 -0600
Message-ID: <20080422023315.GR2775@webber.adilger.int>
References: <20080418210913.GB13973@unused.rdu.redhat.com>
 <20080421220851.GP2775@webber.adilger.int> <480D1238.8080000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45418 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbYDVCdm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 22:33:42 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3M2Xfe7003288
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 19:33:41 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZP00H01GBW8A00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 21 Apr 2008 19:33:41 -0700 (PDT)
In-reply-to: <480D1238.8080000@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 21, 2008  17:16 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > Josef, thanks for doing this work.  Having more than a single filesystem
> > implement FIEMAP (especially a block-mapped one) is very useful.  
> 
> I have an xfs patch too if anyone wants it ;)

Please, do send it on to Dave Chinner.  He was one of the main contributors
to the FIEMAP specification.  He could also give another opinion on whether
the NUM_EXTENTS should return an "extent" for a hole or not.

> So hopefully we can roll out at least 3 fs's when it goes upstream.
> 
> > Did you
> > look at all at making a "generic_fiemap()" function?  It seems very little
> > of ext3_fiemap() is ext3 specific, only the call to ext3_force_commit()
> > (which could just be a sync on the inode), ext3_block_map() (generic for
> > all block-based filesystems), and truncate_mutex (would i_sem be enough?).
> 
> Yep, I agree, it'd be good if ! ->fiemap then go the generic route.
> 
> Although my only question/worry is do all filesystems behave sanely in
> the face of large b_size for getblocks?  All that can handle direct IO
> do anyway.
> 
> >> +int ext3_fiemap(struct inode *inode, unsigned long arg)
> >> +{
> >> +	/*
> >> +	 * if fm_start is in the middle of the current block, get the next
> >> +	 * block so we don't end up returning a start thats before the given
> >> +	 * fm_start
> >> +	 */
> >> +	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
> >> +		inode->i_blkbits;
> > 
> > Hmm, I'd think that if someone is requesting the mapping for bytes [50-5000]
> > they wouldn't be very happy with the mapping returned being [4096-8191],
> > because it is missing part of the requested range.  Instead, the fm_start
> > should be rounded down to the start of the first block and up to the end
> > of the last block to return [0-8191] (fm_start = 0, fm_length = 8192).
> 
> In fact that should be part of the interface definition, right.  Should
> the returned mapping start at the beginning of the block that contains
> the requsted offset, or at the requested offset itself?  I'd vote for
> the former.
> 
> At some point I should probably write some QA for this thing to test
> various file layouts and make sure we get the "right" answers on all
> filesystems...
> 
> -Eric

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

