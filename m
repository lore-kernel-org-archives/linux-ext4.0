From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Sun, 7 Jul 2013 19:34:05 -0400
Message-ID: <20130707233405.GA14906@thunk.org>
References: <51D3269B.5080608@redhat.com>
 <20130707155316.GB11993@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35767 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3GGXeL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jul 2013 19:34:11 -0400
Content-Disposition: inline
In-Reply-To: <20130707155316.GB11993@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 07, 2013 at 11:53:16AM -0400, Theodore Ts'o wrote:
> There seems to be something wrong here.  The test file system was
> created like this:
> 
>   mke2fs -t ext2 -O ^resize_inode -b 1024 -g 1024 -qF /tmp/foo.img 64M
> 
> The file system hence should have 64 block groups, and dumpe2fs before
> the resize looks like this on an x86 system:
> 
> Group 1: (Blocks 1025-2048)
>   Backup superblock at 1025, Group descriptors at 1026-1027
>   Block bitmap at 1028 (+3), Inode bitmap at 1029 (+4)
>   Inode table at 1030-1061 (+5)
> 
> ... and after:
> 
> Group 1: (Blocks 1025-2048)
>   Backup superblock at 1025, Group descriptors at 1026-1089
>   Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>   Inode table at 1092-1123 (+67)
> 
> Note the range of block group #1: 1025-2048, whereas on the PPC,
> apparently the range is quite different: Group 1: (Blocks 1025-1110)
> 
> So there's something else going really wrong here....

I just tried building e2fsprogs 1.42.8 on a powerpc system in a Debian
unstable (sid) chroot, and I'm not able to reproduce this test
failure.  I tried building using both gcc 4.6.4 and gcc 4.8, in case
it was a compiler bug.

So again, there's something really, REALLY wrong....

							- Ted
