From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 11:02:42 -0500
Message-ID: <20080716110242.7cffffa5@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87tzeq0z95.fsf@frosties.localdomain>
	<87ej5ugcn2.fsf@frosties.localdomain>
	<20080716091846.44174452@ichigo>
	<877ibl97jy.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36225 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896AbYGPQCp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jul 2008 12:02:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GG2ipM011174
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:02:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GG2ilv182370
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:02:44 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GG2ivk011154
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 12:02:44 -0400
In-Reply-To: <877ibl97jy.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 17:23:45 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> "Jose R. Santos" <jrs@us.ibm.com> writes:
> 
> > On Wed, 16 Jul 2008 15:52:01 +0200
> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
> >> My test device is exactly 32 TiB large and gives the following:
> >> 
> >> root@beo-13:~# LD_LIBRARY_PATH=/tmpa/ext4 /tmpa/ext4/mke2fs -T ext4dev
> >> -j -m0 /dev/mapper/ext4
> >> mke2fs 1.41.0 (10-Jul-2008)
> >> mke2fs: inode_size (256) * inodes_count (0) too big for a
> >>         filesystem with 0 blocks, specify higher inode_ratio (-i)
> >>         or lower inode count (-N).
> >
> > hehe, I put a FIXME-64 around this since I knew it was going to be a
> > problem.  I just wasn't sure what was the right approach for fixing.
> > You'll have to specify an inode count for now.
> >
> > The "filesystem with 0 blocks" surprise me though.  Looks like I missed
> > something somewhere.
> 
> /*
>  * Set the fs block count
>  */
> void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
> {
>         super->s_blocks_count = blk;
>         if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
>            super->s_blocks_count_hi = (__u64) blk >> 32;
> }
> 
> EXT4_FEATURE_INCOMPAT_64BIT is not set so the upper bits just get
> ignored.
> 
> MfG
>         Goswin
> 
> PS: Should functions that chop off upper bits like that make sure they
> are 0?

I think this is something that need to be cheched at fsck since having
these be non-zero on a non-64-bit FS should be pointing to file system
corruption.  Not sure if its something that need to be done every time
we set a value on the lower bit only though.

We could add error code here but that means that the users of the
routine need to handle the error code.  Determining now if we need to
return errcode_t here now would avoid the need to change the API later.

Ted.  Any comment on this one?

-JRS
