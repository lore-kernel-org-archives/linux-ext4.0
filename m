From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ininitial e2fsprogs TODO list (please expand)
Date: Tue, 15 Apr 2008 21:30:02 -0600
Message-ID: <20080416033002.GZ3106@webber.adilger.int>
References: <20080415115216.1f6868de@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50897 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbYDPDaF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Apr 2008 23:30:05 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3G3U46e028732
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 20:30:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZE00K01F07OA00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 15 Apr 2008 20:30:04 -0700 (PDT)
In-reply-to: <20080415115216.1f6868de@gara.konoha.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 15, 2008  11:52 -0500, Jose R. Santos wrote:
> As discuss on the call yesterday, some folks (my self included) really
> want a TODO list to help them keep track of what things are left undone
> in e2fsprogs as we try to get ext4 out the door.  Here is my initial
> list of items that still need addressing.  Hopefully we can expand this
> list and document it somewhere like the ext4 wiki or the SourceForge
> bug tracker.
> 
> - Rename uninit_groups to uninit_bg to be consistent with other
> defined features.  Retain the old name for historical purpose.
> 
> - The return value of ext2fs_super_and_bgd_loc() is not to be trusted.
> Document this in the source code.
> 
> - Make sure ext2fs_super_and_bgd_loc() does not get used anywhere where
> the return value is expected to be accurate (aside from mke2fs).
> 
> - Remove lazy_bg feature from being set in mke2fs.  Feature has been
> declare a dangerous hack by its creator, remove it to avoid people
> building on top of it.
> 
> - Add flex_bg meta-data grouping support.
> 
> - Remove support for not zeroing the inode tables from the
> uninit_groups patches.  This support is dangerous without a proper
> kernel thread that zeros them in the background when the filesystem is
> mounted.  Depends on the lazy_bg removal.

Something was lost in translation here.  The uninit_groups feature DOES
zero the inode tables by default, and marks the groups with ITABLE_ZEROED.
It is only if "-O uninit_groups,lazy_bg" are both given at the same time
that the itable is not initialized.  That is no different than if lazy_bg
was given by itself.

So nothing needs to be done in e2fsprogs until some time after the kernel
is updated to do the zeroing.

> - Activate undo-manager in mke2fs only when inode tables are not being
> zeroed.  Undo-manager is horribly slow if we need to store the
> information of all the blocks that have been zeroed during mke2fs.  The
> amount of storage needed for the undo on a 16TB filesystem could be
> problematic.  Depends on kernel thread inode table zeroing.
> 
> - Make a 64-bit clean API that extends the existing one.  The current
> API can not support larger than 32-bit blocks so a new set API calls is
> need in order to provide large filesystem support and retain backwards
> compatibility with the old API.
> 
> - 64-bit bitmap interface.  In order to support larger than 32-bit
> blocks, a new bitmap interface is needed that can retain ABI
> compatibility with the old one.

There are some notes on implementing more efficient bitmaps in
https://bugzilla.lustre.org/show_bug.cgi?id=12202

Even without 64-bit filesystems the memory consumption of e2fsck
can be quite high (2^32 blocks ~= 2^32 bytes of RAM for e2fsck).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

