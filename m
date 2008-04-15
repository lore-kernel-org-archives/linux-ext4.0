From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3_valid_block_bitmap: Invalid block bitmap in 2.6.25rc in	memory
Date: Tue, 15 Apr 2008 04:04:22 -0600
Message-ID: <20080415100422.GR3106@webber.adilger.int>
References: <20080412205714.GA6855@basil.nowhere.org>
 <1208184608.3608.7.camel@localhost.localdomain>
 <20080414234059.GM3106@webber.adilger.int> <20080415084710.GB8099@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49441 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYDOKEZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Apr 2008 06:04:25 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3FA4OEf001798
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 03:04:24 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZD00I012ISVE00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 15 Apr 2008 03:04:24 -0700 (PDT)
In-reply-to: <20080415084710.GB8099@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 15, 2008  14:17 +0530, Aneesh Kumar K.V wrote:
> On Mon, Apr 14, 2008 at 05:40:59PM -0600, Andreas Dilger wrote:
> > On Apr 14, 2008  07:50 -0700, Mingming Cao wrote:
> > > On Sat, 2008-04-12 at 22:57 +0200, Andi Kleen wrote:
> > > > FYI, a system here running various 2.6.25rc kernels (latest upto rc7-git6) 
> > > > with longer uptimes suddenly decided to fsck one of its file systems
> > > > due to an error after reboot.
> > > > 
> > > > The error causing this was:
> > > > 
> > > > kernel: EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid block bitmap - block_group = 285, block = 9338882
> > > > 
> > > > detected by the 2.6.25rc7-git6 kernel.
> > > > 
> > > > I don't see any ill effects from it and fsck didn't find anything wrong
> > > > so it must have been something spurious in memory only (or fsck
> > > > fails to check for this condition, but that is hard to imagine) 
> > > 
> > > The ext3_valid_block_bitmap() is to check whether the block or inode
> > > bitmap block is marked as "used" in the block group bitmap, to prevent
> > > allocating blocks from these system meta data blocks.
> > 
> > Right.
> > 
> > > The error messages seems indicating that one of the block group meta
> > > data is corrupted, but I don't why fsck doesn't catch this, Andreas?
> > 
> > It might have been corrupted on read (e.g. bad cable, or bad/wrong
> > data read from disk the first time).
> > 
> > The message itself isn't very useful though.  It should report what it
> > thinks is wrong with the bitmap (e.g. whether block/inode bitmaps are
> > unallocated, which/how many itable blocks are unallocated).
> 
> debugfs should help to find these details right ?

It isn't always possible to run debugfs on a customer system, and the
information would be lost after a reboot or an e2fsck.  The e2fsck might
even happen automatically after an errors=panic reboot and auto e2fsck.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

