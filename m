From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Sun, 7 Jul 2013 11:53:16 -0400
Message-ID: <20130707155316.GB11993@thunk.org>
References: <51D3269B.5080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35675 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3GGPxU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jul 2013 11:53:20 -0400
Content-Disposition: inline
In-Reply-To: <51D3269B.5080608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 02, 2013 at 03:14:35PM -0400, Eric Sandeen wrote:
> Building e2fsprogs 1.42.8 on ppc, I got this:
> 
> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
> 
> Because during the resize step it did this:
> 
> Itable move group 1 block 1030->1092 (diff 62)
> 
> but during e2fsck it found:
> 
> /tmp/e2fsprogs-tmp.uiFhgP: Inode table for group 1 is not in group.  (block 1092)
> 
> i.e. from dumpe2fs we can see:
> 
> Group 1: (Blocks 1025-1110)
>   Backup superblock at 1025, Group descriptors at 1026-1026
>   Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>   Inode table at 1092-1123 (+67)
>                       ^^^^ beyond end of block group

There seems to be something wrong here.  The test file system was
created like this:

  mke2fs -t ext2 -O ^resize_inode -b 1024 -g 1024 -qF /tmp/foo.img 64M

The file system hence should have 64 block groups, and dumpe2fs before
the resize looks like this on an x86 system:

Group 1: (Blocks 1025-2048)
  Backup superblock at 1025, Group descriptors at 1026-1027
  Block bitmap at 1028 (+3), Inode bitmap at 1029 (+4)
  Inode table at 1030-1061 (+5)

... and after:

Group 1: (Blocks 1025-2048)
  Backup superblock at 1025, Group descriptors at 1026-1089
  Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
  Inode table at 1092-1123 (+67)

Note the range of block group #1: 1025-2048, whereas on the PPC,
apparently the range is quite different: Group 1: (Blocks 1025-1110)

So there's something else going really wrong here....

   	   	     	  	       	     - Ted
