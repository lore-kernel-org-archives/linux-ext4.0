From: Andreas Dilger <adilger@sun.com>
Subject: Re: + ext3-fix-online-resize-bug.patch added to -mm tree
Date: Tue, 03 Jun 2008 14:42:08 -0600
Message-ID: <20080603204208.GF2961@webber.adilger.int>
References: <200806030017.m530HMTB007165@imap1.linux-foundation.org>
 <20080602172237.1bfdeb12.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: jbacik@redhat.com, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63775 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618AbYFCUmR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 16:42:17 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m53KgFQC021109
	for <linux-ext4@vger.kernel.org>; Tue, 3 Jun 2008 13:42:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1W00B01M65TE00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 03 Jun 2008 13:42:15 -0700 (PDT)
In-reply-to: <20080602172237.1bfdeb12.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 02, 2008  17:22 -0700, Andrew Morton wrote:
> > ------------------------------------------------------
> > Subject: ext3: fix online resize bug
> > From: Josef Bacik <jbacik@redhat.com>
> > 
> > There is a bug when we are trying to verify that the reserve inode's
> > double indirect blocks point back to the primary gdt blocks.  The fix is
> > obvious, we need to mod the gdb count by the addr's per block.  You can
> > verify this with the following test case
> > 
> > dd if=/dev/zero of=disk1 seek=1024 count=1 bs=100M
> > losetup /dev/loop1 disk1
> > pvcreate /dev/loop1
> > vgcreate loopvg1 /dev/loop1
> > lvcreate -l 100%VG loopvg1 -n looplv1
> > mkfs.ext3 -J size=64 -b 1024 /dev/loopvg1/looplv1
> > mount /dev/loopvg1/looplv1 /mnt/loop
> > dd if=/dev/zero of=disk2 seek=1024 count=1 bs=50M
> > losetup /dev/loop2 disk2
> > pvcreate /dev/loop2
> > vgextend loopvg1 /dev/loop2
> > lvextend -l 100%VG /dev/loopvg1/looplv1
> > resize2fs /dev/loopvg1/looplv1
> > 
> > without this patch the resize2fs fails, with it the resize2fs succeeds.
> > 
> 
> Could I please gather some reviews and ackings on this?

You can add a Signed-off-by: Andreas Dilger <adilger@sun.com>
The wrapping is clearly correct, because the end of the res = 0 loop
is itself wrapping "data" after it exceeds "end".  The current code is
just broken if data >= end to start with.

> Also, do we think it is 2.6.25.x material?

It definitely contains no risk unless you are doing an online resize.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

