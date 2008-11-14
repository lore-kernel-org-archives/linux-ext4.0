From: Andreas Dilger <adilger@sun.com>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Fri, 14 Nov 2008 14:06:12 -0700
Message-ID: <20081114210612.GZ16005@webber.adilger.int>
References: <200811141349.39160.aschultz@warp10.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Schultz <aschultz@warp10.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61006 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYKNVGl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 16:06:41 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAEL6awf008833
	for <linux-ext4@vger.kernel.org>; Fri, 14 Nov 2008 13:06:36 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAC00001D68L000@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 14 Nov 2008 13:06:36 -0800 (PST)
In-reply-to: <200811141349.39160.aschultz@warp10.net>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 14, 2008  13:49 +0100, Andreas Schultz wrote:
> > Unfortunately, ltrace doesn't show what is calling this code, so
> > a stack trace is needed from GDB.
> 
> Got the same problem, here is a GDB backtrace done on Ubuntu Intrepid,
> e2fsprogs 1.41.3:
> 
> (gdb) bt
> #0  0x00007fa619228bcc in ext2fs_new_block (fs=0x1fea860, goal=263012, map=0x1feaa30, ret=0x7fff21668cac) at /build/buildd/e2fsprogs-1.41.3/lib/ext2fs/alloc.c:166
> #1  0x000000000040408d in resize_inode (fs=0x1fea860, new_size=<value optimized out>) at /build/buildd/e2fsprogs-1.41.3/misc/tune2fs.c:1020
> #2  0x0000000000404d83 in main (argc=<value optimized out>, argv=<value optimized out>) at /build/buildd/e2fsprogs-1.41.3/misc/tune2fs.c:1638

Ah, it is trying to find free blocks, but the e2fsprogs allocator is very
inefficient, IIRC, doing a linear scan of the filesystem.  We probably
would be far better off to generate an RB tree of the block maps so that
it is easier to work with lists of blocks that need to be moved or marked
in use for the resized inode table.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

