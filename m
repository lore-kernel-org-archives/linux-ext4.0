From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/2] e2fsprogs: fix data lost with mke2fs -S
Date: Tue, 21 Feb 2012 16:09:28 +0900
Message-ID: <4F434328.2000409@rs.jp.nec.com>
References: <4EF2EA9E.9080500@rs.jp.nec.com> <20120217042038.GA9319@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57789 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2BUHJu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Feb 2012 02:09:50 -0500
In-Reply-To: <20120217042038.GA9319@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

>      mke2fs: allow file systems w/ uninit_bg to be recovered with mke2fs -S
> 
>      The command mke2fs -S is used as a last ditch recovery command to
>      write new superblock and block group descriptors, but _not_ to destroy
>      the inode table in hopes of recovering from a badly corrupted file
>      system.  If the uninit_bg feature is enabled, we need to make sure to
>      clear the unused inodes count field in the block group descriptors or
>      else e2fsck -fy will leave the file system completely empty.
> 
>      Thanks to Akira Fujita for reporting this problem.

I tried to mkfs -S and e2fsck to salvage file
with e2fsprogs 1.42.1 (commit: 5ab348723247).  
But it seemed that the file was removed after e2fsck.
Could you check my method (below script)?

Am I missing something?

---
#!/bin/bash

DEV=""	#device
MP=""   #mount point

mke2fs -t ext4 $DEV
mount -t ext4 $DEV $MP

dd if=/dev/urandom of=$MP/FILE bs=4K count=100  #create file on ext4
ls -l $MP
umount $DEV

dd if=/dev/zero of=$DEV bs=4K count=1 #clear primary SB

mke2fs -t ext4 -S -b 4096 $DEV #write out SB
mount -t ext4 $DEV $MP #can't mount because of the gdp checksum difference

e2fsck $DEV #can salvage? 
mount -t ext4 $DEV $MP
ls -l $MP # It seems that "FILE" is removed
umount $DEV
---

Regards,
Akira Fujita

(2012/02/17 13:20), Ted Ts'o wrote:
> On Thu, Dec 22, 2011 at 05:30:22PM +0900, Akira Fujita wrote:
>> If we run the mke2fs with the -S option and the uninit_bg feature
>> simultaneously, the mke2fs marks blockgroups as uninitialized.
>> The e2fsck which run immediately after the mke2fs
>> removes all of the files.
>>
>> To avoid this, the patch prohibits user from
>> setting the -S option and the uninit_bg feature simultaneously.
> 
> This is not the best fix.  The best fix is to clear the itable_unused
> fields in the block group descriptors if mke2fs -S is set.  See below
> for what I have in my tree.
> 
> 					- Ted
> 
> commit 9b6a158524fe82202bef6d0d8a101b47e6c02b64
> Author: Theodore Ts'o<tytso@mit.edu>
> Date:   Thu Feb 16 23:16:34 2012 -0500
> 
>      mke2fs: allow file systems w/ uninit_bg to be recovered with mke2fs -S
> 
>      The command mke2fs -S is used as a last ditch recovery command to
>      write new superblock and block group descriptors, but _not_ to destroy
>      the inode table in hopes of recovering from a badly corrupted file
>      system.  If the uninit_bg feature is enabled, we need to make sure to
>      clear the unused inodes count field in the block group descriptors or
>      else e2fsck -fy will leave the file system completely empty.
> 
>      Thanks to Akira Fujita for reporting this problem.
> 
>      Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 08789c4..c70c1b4 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2434,6 +2434,17 @@ int main (int argc, char *argv[])
>   	if (super_only) {
>   		fs->super->s_state |= EXT2_ERROR_FS;
>   		fs->flags&= ~(EXT2_FLAG_IB_DIRTY|EXT2_FLAG_BB_DIRTY);
> +		/*
> +		 * The command "mke2fs -S" is used to recover
> +		 * corrupted file systems, so do not mark any of the
> +		 * inodes as unused; we want e2fsck to consider all
> +		 * inodes as potentially containing recoverable data.
> +		 */
> +		if (fs->super->s_feature_ro_compat&
> +		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
> +			for (i = 1; i<  fs->group_desc_count; i++)
> +				ext2fs_bg_itable_unused_set(fs, i, 0);
> +		}
>   	} else {
>   		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
>   		blk64_t rsv = 65536 / fs->blocksize;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
