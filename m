From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2: clear BG_BLOCK_UNINIT in any group containing
 metadata
Date: Wed, 28 Mar 2012 10:28:09 -0500
Message-ID: <4F732E09.2000008@redhat.com>
References: <4F46835F.5080009@redhat.com> <20120327224032.GE11236@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?windows-1252?Q?Luk=E1?= =?windows-1252?Q?=9A_Czerner?=
	<lczerner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758258Ab2C1Q0e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Mar 2012 12:26:34 -0400
In-Reply-To: <20120327224032.GE11236@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/27/12 5:40 PM, Ted Ts'o wrote:
> On Thu, Feb 23, 2012 at 12:20:15PM -0600, Eric Sandeen wrote:
>> Running a test like the m_uninit test runs:
>>
>> # mke2fs -F -o Linux -O uninit_bg testfs 131072
>>
>> results in groups which have blocks allocated for metadata, but
>> which still have the BLOCK_UNINIT flag set:
>>
>> Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
>>   Checksum 0x17c2, unused inodes 2048
>>   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
>>   Inode table at 16387-16642 (+2)
> 
> Sorry for the delay in getting back to you.  The general rule here is
> what triggers BLOCK_UNINIT getting cleared is when we allocate
> metadata blocks for *another* block group in that block group.  When
> we initialize an uninitialized block group, it's easy enough to set
> the bits for the block group's allocation bitmaps and inode tables.
> 
> However, we *don't* want to have to scan all of the block groups to
> see if they have metadata blocks appearing in a particular block
> group, so that's the reason for this rule.
> 
> So in the above dumpe2fs output, since we aren't using flex_bg, the
> only metadata blocks which are in a bg is the bg's own metadata
> blocks, and so that's why it's OK for BLOCK_UNINIT to be set.  This
> isn't a bug.

Hrm, ok, thanks for looking at it.

FWIW, this still fails:

dd if=/dev/zero of=fsfile bs=1M count=128
losetup /dev/loop0 fsfile
mkfs.ext4 -I 256 -b 4096 -N 256 -G 1 -g 256 /dev/loop0 1024
mount /dev/loop0 /mnt/test
mkdir /mnt/test/dir
umount /mnt/test
fsck.ext4 -fn /dev/loop0

with:

Free blocks count wrong for group #2 (253, counted=249).
Fix? no

so will have to look further at what's going on I guess.

-Eric

 
> 					- Ted

