From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext3_valid_block_bitmap: Invalid block bitmap in 2.6.25rc in
	memory
Date: Tue, 15 Apr 2008 14:17:10 +0530
Message-ID: <20080415084710.GB8099@skywalker>
References: <20080412205714.GA6855@basil.nowhere.org> <1208184608.3608.7.camel@localhost.localdomain> <20080414234059.GM3106@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:61966 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYDOIyz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Apr 2008 04:54:55 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id m3F8tboT3645538
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 18:55:38 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3F8lJ3B3633374
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 18:47:19 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3F8lLII000940
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 18:47:21 +1000
Content-Disposition: inline
In-Reply-To: <20080414234059.GM3106@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 14, 2008 at 05:40:59PM -0600, Andreas Dilger wrote:
> On Apr 14, 2008  07:50 -0700, Mingming Cao wrote:
> > On Sat, 2008-04-12 at 22:57 +0200, Andi Kleen wrote:
> > > FYI, a system here running various 2.6.25rc kernels (latest upto rc7-git6) 
> > > with longer uptimes suddenly decided to fsck one of its file systems
> > > due to an error after reboot.
> > > 
> > > The error causing this was:
> > > 
> > > kernel: EXT3-fs error (device dm-0): ext3_valid_block_bitmap: Invalid block bitmap - block_group = 285, block = 9338882
> > > 
> > > detected by the 2.6.25rc7-git6 kernel.
> > > 
> > > I don't see any ill effects from it and fsck didn't find anything wrong
> > > so it must have been something spurious in memory only (or fsck
> > > fails to check for this condition, but that is hard to imagine) 
> > 
> > The ext3_valid_block_bitmap() is to check whether the block or inode
> > bitmap block is marked as "used" in the block group bitmap, to prevent
> > allocating blocks from these system meta data blocks.
> 
> Right.
> 
> > The error messages seems indicating that one of the block group meta
> > data is corrupted, but I don't why fsck doesn't catch this, Andreas?
> 
> It might have been corrupted on read (e.g. bad cable, or bad/wrong
> data read from disk the first time).
> 
> The message itself isn't very useful though.  It should report what it
> thinks is wrong with the bitmap (e.g. whether block/inode bitmaps are
> unallocated, which/how many itable blocks are unallocated).
> 

debugfs should help to find these details right ?


-aneesh
