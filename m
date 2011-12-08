From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH][RFC] ext4: fix a panic by ext4_change_inode_journal_flag()
 with delalloc mode
Date: Thu, 8 Dec 2011 18:40:04 +0800
Message-ID: <CAGBYx2ap6P4JkU=Rp3CDX1EVoeA_WjJ5ta-w_MDduvuD6KxoeA@mail.gmail.com>
References: <20111208192408.03eeeb96.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42739 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1LHKkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Dec 2011 05:40:05 -0500
Received: by ggnr5 with SMTP id r5so1836061ggn.19
        for <linux-ext4@vger.kernel.org>; Thu, 08 Dec 2011 02:40:04 -0800 (PST)
In-Reply-To: <20111208192408.03eeeb96.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The patch [ext4: allocate delalloc blocks before changing journal
mode] should fix up the problem.   Changing journal mode in fly has
some other problems,  the patches fixing the problems had been post
out.  Ted has not picked it up yet.

sync whole file system is not a good idea, we just need to allocate
delalloc blocks of the inode.

Yongqiang.

On Thu, Dec 8, 2011 at 6:24 PM, Toshiyuki Okajima
<toshi.okajima@jp.fujitsu.com> wrote:
> The following reproducer causes a panic.
>
> Reproducer:
> ---------------------------------------------------------------------=
----------
> #!/bin/sh
>
> echo "a" > /tmp/a # file under an ext4 filesystem
> chattr +j /tmp/a
> echo "a" >> /tmp/a
> chattr -j /tmp/a
> ---------------------------------------------------------------------=
----------
>
> The timing when the panic occurs is a time of executing "chattr -j".
> Because "chattr -j" calls ioctl(EXT4_IOC_SETFLAGS) which executes
> ext4_change_inode_journal_flag() to change the attribute of "/tmp/a".
>
> The detailed explanation is as follows:
>
> ext4_change_inode_journal_flag() needs to write all the unprocessed d=
ata of
> this inode (/tmp/a) by jbd2_journal_flush() first. However, if an ext=
4
> filesystem mounts with "delalloc" mode, jbd2_journal_flush() cannot c=
ompletely
> flush all the unprocessed delayed allocation's buffers of this inode =
before
> calling jbd2_log_do_checkpoint().
>
> Therefore, a panic can occur by "BUG_ON(buffer_delay(bh))" of submit_=
bh() via
> __flush_batch() called from jbd2_log_do_checkpoint() because some unp=
rocessed
> delayed allocation's buffers may remain though jbd2_journal_flush() f=
lushed all
> transactions.
>
> The following is an example backtrace():
> ---------------------------------------------------------------------=
----------
> crash> bt
> PID: 4591 =A0 TASK: ffff88007980a0c0 =A0CPU: 2 =A0 COMMAND: "chattr"
> =A0#0 [ffff88003795f900] machine_kexec at ffffffff810356e5
> =A0#1 [ffff88003795f980] crash_kexec at ffffffff810a5c64
> =A0#2 [ffff88003795fa50] oops_end at ffffffff8149bf7b
> =A0#3 [ffff88003795fa80] die at ffffffff810163cb
> =A0#4 [ffff88003795fab0] do_trap at ffffffff8149b960
> =A0#5 [ffff88003795fb00] do_invalid_op at ffffffff810143c5
> =A0#6 [ffff88003795fba0] invalid_op at ffffffff814a4b2b
> =A0 =A0[exception RIP: submit_bh+288]
> =A0 =A0RIP: ffffffff8117e280 =A0RSP: ffff88003795fc58 =A0RFLAGS: 0001=
0202
> =A0 =A0RAX: 000000000004c225 =A0RBX: ffff880071890f00 =A0RCX: 0000000=
000000002
> =A0 =A0RDX: ffff88003795ffd8 =A0RSI: ffff880071890f00 =A0RDI: 0000000=
000000211
> =A0 =A0RBP: ffff88003795fc78 =A0 R8: 0000000091827364 =A0 R9: 0000000=
000000000
> =A0 =A0R10: 0000000000000002 =A0R11: 0000000000000000 =A0R12: 0000000=
000000211
> =A0 =A0R13: 0000000000000211 =A0R14: ffff88003795fca8 =A0R15: 0000000=
000000004
> =A0 =A0ORIG_RAX: ffffffffffffffff =A0CS: 0010 =A0SS: 0018
> =A0#7 [ffff88003795fc50] __sync_dirty_buffer at ffffffff811817dd
> =A0#8 [ffff88003795fc80] write_dirty_buffer at ffffffff8117ede7
> =A0#9 [ffff88003795fca0] __flush_batch at ffffffffa01af8f8 [jbd2]
> #10 [ffff88003795fd00] jbd2_log_do_checkpoint at ffffffffa01afb72 [jb=
d2]
> #11 [ffff88003795fd60] jbd2_journal_flush at ffffffffa01b3e2f [jbd2]
> #12 [ffff88003795fda0] ext4_change_inode_journal_flag at ffffffffa01d=
0ad3 [ext4]
> #13 [ffff88003795fdd0] ext4_ioctl at ffffffffa01d66b6 [ext4]
> #14 [ffff88003795fea0] vfs_ioctl at ffffffff81162b1d
> #15 [ffff88003795feb0] do_vfs_ioctl at ffffffff81163145
> #16 [ffff88003795ff30] sys_ioctl at ffffffff81163644
> #17 [ffff88003795ff80] system_call_fastpath at ffffffff814a2b42
> =A0 =A0RIP: 00000034930d95f7 =A0RSP: 00007fff656ceae8 =A0RFLAGS: 0001=
0213
> =A0 =A0RAX: 0000000000000010 =A0RBX: ffffffff814a2b42 =A0RCX: 0000003=
4930d95f7
> =A0 =A0RDX: 00007fff656ceb8c =A0RSI: 0000000040086602 =A0RDI: 0000000=
000000003
> =A0 =A0RBP: 0000000000080000 =A0 R8: 0000000000000000 =A0 R9: 0000000=
000000000
> =A0 =A0R10: 0000000000000001 =A0R11: 0000000000000246 =A0R12: 0000000=
000004000
> =A0 =A0R13: 0000000000000001 =A0R14: 0000000000000000 =A0R15: 0000000=
000000003
> =A0 =A0ORIG_RAX: 0000000000000010 =A0CS: 0033 =A0SS: 002b
> ---------------------------------------------------------------------=
----------
>
> Therefore, we must flush all unprocessed delayed allocation's buffers=
 and turn
> "delalloc" mode off before jbd2_journal_flush() calls. Then, we must =
turn
> "delalloc" mode on after jbd2_journal_flush() finishes.
>
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
> =A0fs/ext4/ext4.h =A0| =A0 =A03 +++
> =A0fs/ext4/inode.c | =A0 18 ++++++++++++++++++
> =A02 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 5b0e26a..3eeb68b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1249,6 +1249,9 @@ struct ext4_sb_info {
>
> =A0 =A0 =A0 =A0/* record the last minlen when FITRIM is called. */
> =A0 =A0 =A0 =A0atomic_t s_last_trim_minblks;
> +
> + =A0 =A0 =A0 /* to sync the delayed allocation's buffers */
> + =A0 =A0 =A0 atomic_t s_need_da_sync;
> =A0};
>
> =A0static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 848f436..8d317a3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2368,6 +2368,14 @@ static int ext4_nonda_switch(struct super_bloc=
k *sb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Second case to switch to non dealloc mode, if we w=
ant to write all the ext4
> + =A0 =A0 =A0 =A0* data out.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (atomic_read(&sbi->s_need_da_sync) > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Even if we don't switch but are nearing capacity,
> =A0 =A0 =A0 =A0 * start pushing delalloc when 1/2 of free blocks are =
dirty.
> @@ -4665,6 +4673,8 @@ int ext4_change_inode_journal_flag(struct inode=
 *inode, int val)
> =A0 =A0 =A0 =A0journal_t *journal;
> =A0 =A0 =A0 =A0handle_t *handle;
> =A0 =A0 =A0 =A0int err;
> + =A0 =A0 =A0 struct super_block *sb =3D inode->i_sb;
> + =A0 =A0 =A0 struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We have to be very careful here: changing a data bl=
ock's
> @@ -4682,6 +4692,13 @@ int ext4_change_inode_journal_flag(struct inod=
e *inode, int val)
> =A0 =A0 =A0 =A0if (is_journal_aborted(journal))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EROFS;
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* To write all delayed allocation's buffers out befo=
re calling
> + =A0 =A0 =A0 =A0* jbd2_journal_flush(). Because it cannot flush the =
buffers.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 atomic_inc(&sbi->s_need_da_sync);
> + =A0 =A0 =A0 sync_filesystem(sb);
> +
> =A0 =A0 =A0 =A0jbd2_journal_lock_updates(journal);
> =A0 =A0 =A0 =A0jbd2_journal_flush(journal);
>
> @@ -4700,6 +4717,7 @@ int ext4_change_inode_journal_flag(struct inode=
 *inode, int val)
> =A0 =A0 =A0 =A0ext4_set_aops(inode);
>
> =A0 =A0 =A0 =A0jbd2_journal_unlock_updates(journal);
> + =A0 =A0 =A0 atomic_dec(&sbi->s_need_da_sync);
>
> =A0 =A0 =A0 =A0/* Finally we can mark the inode as dirty. */
>
> --
> 1.5.5.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
