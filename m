From: "Bjoern Slotkowski" <bjoern.slotkowski@imc-berlin.de>
Subject: AW: Questions concerning ext2 filesystem:  ext2_statfs
Date: Mon, 3 Jan 2011 14:12:04 +0100
Message-ID: <FPEIIEKCABPOOBGGCOCHOEMNDHAA.bjoern.slotkowski@imc-berlin.de>
References: <F6FD8E03-CEEF-4551-8164-C03492D25275@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.imc-berlin.de ([82.144.33.98]:33235 "EHLO mx1.imc-berlin.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1ACNMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 08:12:10 -0500
In-Reply-To: <F6FD8E03-CEEF-4551-8164-C03492D25275@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Andreas,

thanks a lot for your answers.

We have kernel version 2.6.14 thats really old I know.

When I looked at a newer version (2.6.31.8) the handling in ext2_statfs
seemed to be the same, but you are right I did not see all conditions which
lead to the calculation of the overhead.
My fault sorry.


But there is still one thing also in the newer kernel:
f_bfree and f_ffree are determined by functions "ext2_count_free_blocks" and
"ext2_count_free_inodes"
which iterate through s_groups_count which needs a lot of time.

When I look at ext3/super.c and ext4/super.c the member variables
s_freeblocks_counter and s_freeinodes_counter are used directly in functions
*_statfs.

Probably there is potential for an optimization.

When patching the handling of the newer linux version to our version,
increment s_freeinodes_counter in function "ext2_release_inode" and
use the optimization by using s_freeblocks_counter and s_freeinodes_counter
directly
your software works really fine.


Best regards,

Bjoern



--
imc Messsysteme GmbH
Bereich Entwicklung / Dept. Development
Voltastra?e 5
D-13355 Berlin
Germany
Tel:   +49 30 46 70 90 23
Fax:   +49 30 46 31 57 6
mailto:Bjoern.Slotkowski@imc-berlin.de
Homepage: http://www.imc-berlin.de

Sitz der Gesellschaft : Berlin
Handelsregister       : Berlin-Charlottenburg HRB 28778
Geschaftsfuhrer       : Dr.-Ing. Dietmar Sprenger



> -----Ursprungliche Nachricht-----
> Von: linux-ext4-owner@vger.kernel.org
> [mailto:linux-ext4-owner@vger.kernel.org]Im Auftrag von Andreas Dilger
> Gesendet: Mittwoch, 22. Dezember 2010 18:01
> An: Bjoern Slotkowski
> Cc: linux-ext4@vger.kernel.org
> Betreff: Re: Questions concerning ext2 filesystem: ext2_statfs
>
>
> On 2010-12-22, at 05:14, Bjoern Slotkowski wrote:
> > When looking for free blocks and inodes in function ext2_statfs the
> > overhead, free inodes and free blocks are newly calculated by iterating
> > through all inodes and blocks and look if they are free or not.
> >
> > On the other hand free inodes and free blocks are held in the
> > structure-members s_freeinode_count and s_free_block_count of the
> > superblock info.
> >
> >
> > Now my questions:
> >
> > Why is the overhead calculated ?
> > Isn't it is constant since filling the superblock ?
> > Wy are free blocks and free inodes are calculated every time,
> > when they are held in s_freeinode_count and s_free_block_count ?
>
> They are not calculated every time ext2_statfs() is called.  This
> overhead is only calculated if sbi->s_blocks_last does not match
> the total number of blocks the last time the function was called.
>
> Normally this means the overhead is computed once when the filesystem
> is first mounted, and never computed again unless the filesystem is
> resized online.
>
> > Isn't it is possible to use these variables directly ?
>
> No, because the overhead is unrelated to the "free" blocks count,
> but rather the difference between the "free" and "avail" blocks.
>
> > The background for these questions is as it always is:
> > We have a problem using 320 GB harddrives instead of 80 GB harddrives
> > with ext2.
> >
> > Before writing to the harddrive our software looks for enough space
> > to make sure the data can be stored safely.
> > This leads to heavy performance problems when using larger disks.
>
> What version of the kernel are you using?
>
> > We can reduce the check for enough space to every 10th or 100th write
> > operation, but at some point our software has to check and this may
> > lead to a loss of data because the system is busy calculating the free
> > inodes and blocks.
>
> Isn't that really the filesystem's job, and not the job of your software?
> The job of the software is to write until ENOSPC is returned by the
> filesystem.  There is no need to call statfs() at all before a write.
>
> > Our solution will be to create a patch using the structure members
> > s_freeinode_count, s_free_block_count
> > and create a new member s_overhead_count and use them directly.
> > s_overhead_count is calculated once when filling the superblock.
> >
> > Is this a good solution or are there circumstances which can lead to a
> > misbehavior ?
>
> Please see any newer kernel release.  There is no scanning done anymore.
> I see commit 2235219b7721b8e74de6841e79240936561a2b63 in 2007 implemented
> this, which is included in vanilla 2.6.23.
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

