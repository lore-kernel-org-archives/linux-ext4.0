From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext2: Retry block allocation if new blocks are
	allocated from system zone.
Date: Wed, 26 Mar 2008 13:08:00 +0530
Message-ID: <20080326073800.GA7325@skywalker>
References: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080325235649.GY2691@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:49159 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYCZHiP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Mar 2008 03:38:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2Q7bqTG008531
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 18:37:52 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2Q7g0AO256354
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 18:42:00 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2Q7cJnn015491
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 18:38:19 +1100
Content-Disposition: inline
In-Reply-To: <20080325235649.GY2691@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 25, 2008 at 05:56:49PM -0600, Andreas Dilger wrote:
> On Mar 26, 2008  00:26 +0530, Aneesh Kumar K.V wrote:
> > If the block allocator gets blocks out of system zone ext2 calls
> > ext2_error. But if the file system is mounted with errors=continue
> > retry block allocation. We need to mark the system zone
> > blocks as in use to make sure retry don't pick them again
> > 
> > System zone is the block range mapping block bitmap, inode bitmap
> > and inode table.
> 
> Nack * 3.  It appears that this will spin in a loop, because retry_alloc:
> will not change the group that is being used, and extN_valid_block_bitmap()
> does nothing to fix up the bitmap to avoid re-allocating the same blocks.


As also discussed on irc, ext2_try_to_allocate(fs/ext2/balloc.c:738)
marks the blocks allocated as in use. So we will not really spin in
loop here. Same is true for ext3 and ext4. (fs/ext4/balloc.c:1066) for
mballoc it is done as a part of patch.

> 
> Instead, it seems safest that extN_new_blocks() should skip the group
> entirely after marking the group as having no free blocks, so the allocator
> will no longer choose it.  This also means that when freeing blocks it
> needs to watch out for underflow of the ->bg_free_blocks_count value,
> which is itself a good safety measure.

Agreed. As you suggested on irc, i will try to introduce EXT4_BG_CORRUPT
and ignore the group which has EXT4_BG_CORRUPT set in block allocation.
I would also try to do e2fsck changes that will clear this flag after
fixing the bitmap corruption.

-aneesh
