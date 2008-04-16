From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Ininitial e2fsprogs TODO list (please expand)
Date: Tue, 15 Apr 2008 23:35:10 -0500
Message-ID: <20080415233510.11f9179f@gara.konoha.net>
References: <20080415115216.1f6868de@gara.konoha.net>
	<20080416033002.GZ3106@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35810 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYDPEfi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2008 00:35:38 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3G4Zb7o018776
	for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2008 00:35:37 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3G4Zb9N205440
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 22:35:37 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3G4Zbuo022409
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 22:35:37 -0600
In-Reply-To: <20080416033002.GZ3106@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 15 Apr 2008 21:30:02 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Apr 15, 2008  11:52 -0500, Jose R. Santos wrote:
> > As discuss on the call yesterday, some folks (my self included) really
> > want a TODO list to help them keep track of what things are left undone
> > in e2fsprogs as we try to get ext4 out the door.  Here is my initial
> > list of items that still need addressing.  Hopefully we can expand this
> > list and document it somewhere like the ext4 wiki or the SourceForge
> > bug tracker.
> > 
> > - Rename uninit_groups to uninit_bg to be consistent with other
> > defined features.  Retain the old name for historical purpose.
> > 
> > - The return value of ext2fs_super_and_bgd_loc() is not to be trusted.
> > Document this in the source code.
> > 
> > - Make sure ext2fs_super_and_bgd_loc() does not get used anywhere where
> > the return value is expected to be accurate (aside from mke2fs).
> > 
> > - Remove lazy_bg feature from being set in mke2fs.  Feature has been
> > declare a dangerous hack by its creator, remove it to avoid people
> > building on top of it.
> > 
> > - Add flex_bg meta-data grouping support.
> > 
> > - Remove support for not zeroing the inode tables from the
> > uninit_groups patches.  This support is dangerous without a proper
> > kernel thread that zeros them in the background when the filesystem is
> > mounted.  Depends on the lazy_bg removal.
> 
> Something was lost in translation here.  The uninit_groups feature DOES
> zero the inode tables by default, and marks the groups with ITABLE_ZEROED.
> It is only if "-O uninit_groups,lazy_bg" are both given at the same time
> that the itable is not initialized.  That is no different than if lazy_bg
> was given by itself.

Yes, I understand this part.
 
> So nothing needs to be done in e2fsprogs until some time after the kernel
> is updated to do the zeroing.

The problem is that not initializing the inode table on the uninit
block group patch depends on a feature (lazy_bg) that Ted wants
removed.  I believe that just removing the lazy_bg feature would be
enough to remove this capability from the uninit patch, but was not
entirely sure so I put the item just to keep track of it.

If lazy_bg is in fact removed from e2fsprogs, I suppose we need to add
another item to enable lazy setup of the inode tables once the proper
support in the kernel is establish.
 
> > - Activate undo-manager in mke2fs only when inode tables are not being
> > zeroed.  Undo-manager is horribly slow if we need to store the
> > information of all the blocks that have been zeroed during mke2fs.  The
> > amount of storage needed for the undo on a 16TB filesystem could be
> > problematic.  Depends on kernel thread inode table zeroing.
> > 
> > - Make a 64-bit clean API that extends the existing one.  The current
> > API can not support larger than 32-bit blocks so a new set API calls is
> > need in order to provide large filesystem support and retain backwards
> > compatibility with the old API.
> > 
> > - 64-bit bitmap interface.  In order to support larger than 32-bit
> > blocks, a new bitmap interface is needed that can retain ABI
> > compatibility with the old one.
> 
> There are some notes on implementing more efficient bitmaps in
> https://bugzilla.lustre.org/show_bug.cgi?id=12202
> 
> Even without 64-bit filesystems the memory consumption of e2fsck
> can be quite high (2^32 blocks ~= 2^32 bytes of RAM for e2fsck).
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 



-JRS
