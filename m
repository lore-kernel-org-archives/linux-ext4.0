From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Questions concerning ext2 filesystem:  ext2_statfs
Date: Wed, 22 Dec 2010 10:01:07 -0700
Message-ID: <F6FD8E03-CEEF-4551-8164-C03492D25275@dilger.ca>
References: <FPEIIEKCABPOOBGGCOCHIEBLDHAA.bjoern.slotkowski@imc-berlin.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bjoern Slotkowski <bjoern.slotkowski@imc-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:54947 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0LVRBL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Dec 2010 12:01:11 -0500
In-Reply-To: <FPEIIEKCABPOOBGGCOCHIEBLDHAA.bjoern.slotkowski@imc-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-12-22, at 05:14, Bjoern Slotkowski wrote:
> When looking for free blocks and inodes in function ext2_statfs the
> overhead, free inodes and free blocks are newly calculated by iterating
> through all inodes and blocks and look if they are free or not.
> 
> On the other hand free inodes and free blocks are held in the
> structure-members s_freeinode_count and s_free_block_count of the
> superblock info.
> 
> 
> Now my questions:
> 
> Why is the overhead calculated ?
> Isn't it is constant since filling the superblock ?
> Wy are free blocks and free inodes are calculated every time,
> when they are held in s_freeinode_count and s_free_block_count ?

They are not calculated every time ext2_statfs() is called.  This
overhead is only calculated if sbi->s_blocks_last does not match
the total number of blocks the last time the function was called.

Normally this means the overhead is computed once when the filesystem
is first mounted, and never computed again unless the filesystem is
resized online.

> Isn't it is possible to use these variables directly ?

No, because the overhead is unrelated to the "free" blocks count,
but rather the difference between the "free" and "avail" blocks.

> The background for these questions is as it always is:
> We have a problem using 320 GB harddrives instead of 80 GB harddrives
> with ext2.
> 
> Before writing to the harddrive our software looks for enough space
> to make sure the data can be stored safely.
> This leads to heavy performance problems when using larger disks.

What version of the kernel are you using?

> We can reduce the check for enough space to every 10th or 100th write
> operation, but at some point our software has to check and this may
> lead to a loss of data because the system is busy calculating the free
> inodes and blocks.

Isn't that really the filesystem's job, and not the job of your software?
The job of the software is to write until ENOSPC is returned by the
filesystem.  There is no need to call statfs() at all before a write.

> Our solution will be to create a patch using the structure members
> s_freeinode_count, s_free_block_count
> and create a new member s_overhead_count and use them directly.
> s_overhead_count is calculated once when filling the superblock.
> 
> Is this a good solution or are there circumstances which can lead to a
> misbehavior ?

Please see any newer kernel release.  There is no scanning done anymore.
I see commit 2235219b7721b8e74de6841e79240936561a2b63 in 2007 implemented
this, which is included in vanilla 2.6.23.

Cheers, Andreas





