From: Chen Huan <chenhuan@nrchpc.ac.cn>
Subject: Re: e2fsck aborts when invalid indirect block is encountered
Date: Thu, 1 Sep 2011 16:52:04 +0800
Message-ID: <20110901085204.GA12928@notebook.chenhuan>
References: <20110901063410.GA8313@notebook.chenhuan>
 <6826A7C1-1DE4-4F0B-8654-201A3F6D1BF2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [221.122.61.228] ([221.122.61.228]:38016 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752598Ab1IAKMC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 06:12:02 -0400
Content-Disposition: inline
In-Reply-To: <6826A7C1-1DE4-4F0B-8654-201A3F6D1BF2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Andreas Dilger <adilger@dilger.ca> [2011-09-01 02:17:14 -0600]:

> On 2011-09-01, at 12:34 AM, Chen Huan wrote:
> > During a recent read-only checking of an corrupted ext3 file system,
> > I found a strange behaviour of e2fsck: when an inode has an invalid
> > indirect block number, e2fsck aborts with the following message:
> > 
> >    e2fsck 1.39 (29-May-2006)
> 
> Please retest with a new version of e2fsprogs.  The current release
> version is 1.41.14, and the work-in-progress for version 1.42 is
> available via Git.

The problem remains in e2fsck 1.42-WIP (02-Jul-2011)

> 
> >    Pass 1: Checking inodes, blocks, and sizes
> >    Inode 12 has illegal block(s).  Clear? no
> > 
> >    Illegal block #-1 (4294967295) in inode 12.  IGNORED.
> >    Error while iterating over blocks in inode 12: Illegal indirect block found
> >    e2fsck: aborted
> > 
> > You can reproduce it with this code snippet:
> > 
> >    #!/bin/sh
> > 
> >    dev=/dev/sde
> >    mnt=/mnt
> > 
> >    mkfs.ext3 -F $dev
> >    mount $dev $mnt
> >    dd if=/dev/zero of=$mnt/file bs=1M count=1
> >    umount $dev
> >    debugfs -w -R 'sif file block[IND] 0xFFFFFFFF' $dev
> >    e2fsck -f -n $dev
> > 
> > Doing a fixing without -n option can safely delete this bad blocknum.
> > 
> > My question is: Is this behaviour a bug or intended?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
