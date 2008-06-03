From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ext3-fix-online-resize-bug.patch added to -mm tree
Date: Tue, 3 Jun 2008 13:54:01 -0700
Message-ID: <20080603135401.ed50fe7c.akpm@linux-foundation.org>
References: <200806030017.m530HMTB007165@imap1.linux-foundation.org>
	<20080602172237.1bfdeb12.akpm@linux-foundation.org>
	<20080603204208.GF2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jbacik@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752079AbYFCUyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 16:54:22 -0400
In-Reply-To: <20080603204208.GF2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 03 Jun 2008 14:42:08 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Jun 02, 2008  17:22 -0700, Andrew Morton wrote:
> > > ------------------------------------------------------
> > > Subject: ext3: fix online resize bug
> > > From: Josef Bacik <jbacik@redhat.com>
> > > 
> > > There is a bug when we are trying to verify that the reserve inode's
> > > double indirect blocks point back to the primary gdt blocks.  The fix is
> > > obvious, we need to mod the gdb count by the addr's per block.  You can
> > > verify this with the following test case
> > > 
> > > dd if=/dev/zero of=disk1 seek=1024 count=1 bs=100M
> > > losetup /dev/loop1 disk1
> > > pvcreate /dev/loop1
> > > vgcreate loopvg1 /dev/loop1
> > > lvcreate -l 100%VG loopvg1 -n looplv1
> > > mkfs.ext3 -J size=64 -b 1024 /dev/loopvg1/looplv1
> > > mount /dev/loopvg1/looplv1 /mnt/loop
> > > dd if=/dev/zero of=disk2 seek=1024 count=1 bs=50M
> > > losetup /dev/loop2 disk2
> > > pvcreate /dev/loop2
> > > vgextend loopvg1 /dev/loop2
> > > lvextend -l 100%VG /dev/loopvg1/looplv1
> > > resize2fs /dev/loopvg1/looplv1
> > > 
> > > without this patch the resize2fs fails, with it the resize2fs succeeds.
> > > 
> > 
> > Could I please gather some reviews and ackings on this?
> 
> You can add a Signed-off-by: Andreas Dilger <adilger@sun.com>
> The wrapping is clearly correct, because the end of the res = 0 loop
> is itself wrapping "data" after it exceeds "end".  The current code is
> just broken if data >= end to start with.

OK, thanks.

I made that an Acked-by: (as per Documentation/SubmittingPatches).  I
could have made it a Reviewed-by: (which is stronger) but whatever.

> > Also, do we think it is 2.6.25.x material?
> 
> It definitely contains no risk unless you are doing an online resize.

That didn't answer my question ;)
