From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 17:23:45 +0200
Message-ID: <877ibl97jy.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<87ej5ugcn2.fsf@frosties.localdomain> <20080716091846.44174452@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:48603 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbYGPPXr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 11:23:47 -0400
In-Reply-To: <20080716091846.44174452@ichigo> (Jose R. Santos's message of
	"Wed, 16 Jul 2008 09:18:46 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> On Wed, 16 Jul 2008 15:52:01 +0200
> Goswin von Brederlow <goswin-v-b@web.de> wrote:
>> My test device is exactly 32 TiB large and gives the following:
>> 
>> root@beo-13:~# LD_LIBRARY_PATH=/tmpa/ext4 /tmpa/ext4/mke2fs -T ext4dev
>> -j -m0 /dev/mapper/ext4
>> mke2fs 1.41.0 (10-Jul-2008)
>> mke2fs: inode_size (256) * inodes_count (0) too big for a
>>         filesystem with 0 blocks, specify higher inode_ratio (-i)
>>         or lower inode count (-N).
>
> hehe, I put a FIXME-64 around this since I knew it was going to be a
> problem.  I just wasn't sure what was the right approach for fixing.
> You'll have to specify an inode count for now.
>
> The "filesystem with 0 blocks" surprise me though.  Looks like I missed
> something somewhere.

/*
 * Set the fs block count
 */
void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
{
        super->s_blocks_count = blk;
        if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
           super->s_blocks_count_hi = (__u64) blk >> 32;
}

EXT4_FEATURE_INCOMPAT_64BIT is not set so the upper bits just get
ignored.

MfG
        Goswin

PS: Should functions that chop off upper bits like that make sure they
are 0?
