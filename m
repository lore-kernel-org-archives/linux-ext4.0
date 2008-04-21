From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] fiemap support for ext3
Date: Mon, 21 Apr 2008 16:08:51 -0600
Message-ID: <20080421220851.GP2775@webber.adilger.int>
References: <20080418210913.GB13973@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:45416 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbYDUWI4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 18:08:56 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3LM8slM014809
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 15:08:55 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZP00I013ZOXB00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 21 Apr 2008 15:08:54 -0700 (PDT)
In-reply-to: <20080418210913.GB13973@unused.rdu.redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 18, 2008  17:09 -0400, Josef Bacik wrote:
> Here is my patch for fiemap support on ext3.  The main reason for doing this is
> because it will make it easier for application developers who are wanting to
> take advantage of fiemap on extent based fs's to be able to use the same
> interface for ext3 as well without having to fallback onto something like
> fibmap.  Fibmap also means you are calling ext3_get_block for _every_ block in
> the file, which is ineffecient when ext3_get_blocks can map multiple contiguous
> blocks all at once, reducing the number of times you have to call
> ext3_get_blocks.  Tested this with sandeens fiemap test program and verified it
> with filefrag.  Thanks much,
> 
> Signed-off-by: Josef Bacik <jbacik@redhat.com>

Josef, thanks for doing this work.  Having more than a single filesystem
implement FIEMAP (especially a block-mapped one) is very useful.  Did you
look at all at making a "generic_fiemap()" function?  It seems very little
of ext3_fiemap() is ext3 specific, only the call to ext3_force_commit()
(which could just be a sync on the inode), ext3_block_map() (generic for
all block-based filesystems), and truncate_mutex (would i_sem be enough?).

> +int ext3_fiemap(struct inode *inode, unsigned long arg)
> +{
> +	/*
> +	 * if fm_start is in the middle of the current block, get the next
> +	 * block so we don't end up returning a start thats before the given
> +	 * fm_start
> +	 */
> +	start_blk = (fiemap_s->fm_start + (1 << inode->i_blkbits) - 1) >>
> +		inode->i_blkbits;

Hmm, I'd think that if someone is requesting the mapping for bytes [50-5000]
they wouldn't be very happy with the mapping returned being [4096-8191],
because it is missing part of the requested range.  Instead, the fm_start
should be rounded down to the start of the first block and up to the end
of the last block to return [0-8191] (fm_start = 0, fm_length = 8192).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

