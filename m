From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: allocate inode table wholly within group
Date: Sun, 7 Jul 2013 21:59:14 -0400 (EDT)
Message-ID: <28A950D9-4C20-45C1-A26B-2E45AE8B8EFF@redhat.com>
References: <51D3269B.5080608@redhat.com> <20130707155316.GB11993@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:42734 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3GHB7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Jul 2013 21:59:17 -0400
In-Reply-To: <20130707155316.GB11993@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 7, 2013, at 10:53 AM, "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Tue, Jul 02, 2013 at 03:14:35PM -0400, Eric Sandeen wrote:
>> Building e2fsprogs 1.42.8 on ppc, I got this:
>> 
>> r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
>> 
>> Because during the resize step it did this:
>> 
>> Itable move group 1 block 1030->1092 (diff 62)
>> 
>> but during e2fsck it found:
>> 
>> /tmp/e2fsprogs-tmp.uiFhgP: Inode table for group 1 is not in group.  (block 1092)
>> 
>> i.e. from dumpe2fs we can see:
>> 
>> Group 1: (Blocks 1025-1110)
>>  Backup superblock at 1025, Group descriptors at 1026-1026
>>  Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>>  Inode table at 1092-1123 (+67)
>>                      ^^^^ beyond end of block group
> 
> There seems to be something wrong here.  The test file system was
> created like this:
> 
>  mke2fs -t ext2 -O ^resize_inode -b 1024 -g 1024 -qF /tmp/foo.img 64M
> 
> The file system hence should have 64 block groups, and dumpe2fs before
> the resize looks like this on an x86 system:
> 
> Group 1: (Blocks 1025-2048)
>  Backup superblock at 1025, Group descriptors at 1026-1027
>  Block bitmap at 1028 (+3), Inode bitmap at 1029 (+4)
>  Inode table at 1030-1061 (+5)
> 
> ... and after:
> 
> Group 1: (Blocks 1025-2048)
>  Backup superblock at 1025, Group descriptors at 1026-1089
>  Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
>  Inode table at 1092-1123 (+67)
> 
> Note the range of block group #1: 1025-2048, whereas on the PPC,
> apparently the range is quite different: Group 1: (Blocks 1025-1110)
> 
> So there's something else going really wrong here....
> 
>                                             - Ted

Perhaps so, I'll look into it more.  But nonetheless isn't the patch correct?

Don't we need to ensure the inode table is wholly within be group, however we may have gotten here?

-Eric