From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ext3-fix-online-resize-bug.patch added to -mm tree
Date: Mon, 2 Jun 2008 17:22:37 -0700
Message-ID: <20080602172237.1bfdeb12.akpm@linux-foundation.org>
References: <200806030017.m530HMTB007165@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: jbacik@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbYFCAW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 20:22:59 -0400
In-Reply-To: <200806030017.m530HMTB007165@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 02 Jun 2008 17:17:22 -0700
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      ext3: fix online resize bug
> has been added to the -mm tree.  Its filename is
>      ext3-fix-online-resize-bug.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: ext3: fix online resize bug
> From: Josef Bacik <jbacik@redhat.com>
> 
> There is a bug when we are trying to verify that the reserve inode's
> double indirect blocks point back to the primary gdt blocks.  The fix is
> obvious, we need to mod the gdb count by the addr's per block.  You can
> verify this with the following test case
> 
> dd if=/dev/zero of=disk1 seek=1024 count=1 bs=100M
> losetup /dev/loop1 disk1
> pvcreate /dev/loop1
> vgcreate loopvg1 /dev/loop1
> lvcreate -l 100%VG loopvg1 -n looplv1
> mkfs.ext3 -J size=64 -b 1024 /dev/loopvg1/looplv1
> mount /dev/loopvg1/looplv1 /mnt/loop
> dd if=/dev/zero of=disk2 seek=1024 count=1 bs=50M
> losetup /dev/loop2 disk2
> pvcreate /dev/loop2
> vgextend loopvg1 /dev/loop2
> lvextend -l 100%VG /dev/loopvg1/looplv1
> resize2fs /dev/loopvg1/looplv1
> 
> without this patch the resize2fs fails, with it the resize2fs succeeds.
> 

Could I please gather some reviews and ackings on this?

Also, do we think it is 2.6.25.x material?

Thanks.
