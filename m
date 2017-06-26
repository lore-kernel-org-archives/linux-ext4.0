From: Alex Xu <alex_y_xu@yahoo.ca>
Subject: bfq/ext4 disk IO hangs forever on resume
Date: Sun, 25 Jun 2017 23:07:56 -0400
Message-ID: <20170625230756.68b4de21.alex_y_xu@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm23.bullet.mail.gq1.yahoo.com ([98.136.217.6]:33442 "EHLO
        nm23.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751525AbdFZDID (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 25 Jun 2017 23:08:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I get hangs when resuming when using bfq-mq with ext4 on 4.12-rc6+
(currently a4fd8b3accf43d407472e34403d4b0a4df5c0e71).

Steps to reproduce:
1. boot computer
2. systemctl suspend
3. wait few seconds
4. press power button
5. type "ls" into console or SSH or do anything that does disk IO

Expected results:
Command is executed.

Actual results:
Command hangs.

lockdep has no comments, but sysrq-d shows that i_mutex_dir_key and
jbd2_handle are held by multiple processes, leading me to suspect that
ext4 is at least partially involved. [0]

sysrq-w lists many blocked processes [1]

This happens consistently, every time I resume the system from
suspend-to-RAM using this configuration. Switching to noop IO scheduler
makes it stop happening. I haven't tried switching filesystems yet.

I can do more debugging (enable KASAN or whatever), but usually when I
bother doing that I find someone has already sent a patch for the issue.

Please CC me on replies.

Cheers,
Alex.

[0]

4 locks held by systemd/384:                                                                                                                                                                                                                 
 #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811b0e5f>] mnt_want_write+0x1f/0x50
 #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff8119b7ce>] do_rmdir+0x15e/0x1e0
 #2:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff81195ee0>] vfs_rmdir+0x50/0x130
 #3:  (jbd2_handle){++++..}, at: [<ffffffff8124f17f>] start_this_handle+0xff/0x430
4 locks held by syncthing/279: 
 #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff811ade1e>] __fdget_pos+0x3e/0x50
 #1:  (sb_writers#3){.+.+.+}, at: [<ffffffff8118b04c>] vfs_write+0x17c/0x1d0
 #2:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff81217977>] ext4_file_write_iter+0x57/0x350
 #3:  (jbd2_handle){++++..}, at: [<ffffffff8124f17f>] start_this_handle+0xff/0x430
2 locks held by zsh/238:
 #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff816fbeaf>] ldsem_down_read+0x1f/0x30
 #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff8134fbb0>] n_tty_read+0xb0/0x8b0
2 locks held by sddm-greeter/267:
 #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811b0e5f>] mnt_want_write+0x1f/0x50
 #1:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff8119a698>] path_openat+0x2d8/0xa10
2 locks held by kworker/u16:28/330:
 #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810a1ef3>] process_one_work+0x1c3/0x420
 #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810a1ef3>] process_one_work+0x1c3/0x420
1 lock held by zsh/382:
 #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81192570>] prepare_bprm_creds+0x30/0x70

[1]

  task                        PC stack   pid father
systemd         D    0   384      0 0x00000000   
Call Trace:
 __schedule+0x295/0x7c0
 ? bit_wait+0x50/0x50
 ? bit_wait+0x50/0x50
 schedule+0x31/0x80
 io_schedule+0x11/0x40
 bit_wait_io+0xc/0x50
 __wait_on_bit+0x53/0x80
 ? bit_wait+0x50/0x50
 out_of_line_wait_on_bit+0x6e/0x80
 ? autoremove_wake_function+0x30/0x30
 do_get_write_access+0x20b/0x420
 jbd2_journal_get_write_access+0x2c/0x60
 __ext4_journal_get_write_access+0x55/0xa0
 ext4_delete_entry+0x8c/0x140
 ? __ext4_journal_start_sb+0x4e/0xa0
 ext4_rmdir+0x114/0x250
 vfs_rmdir+0x6e/0x130
 do_rmdir+0x1a3/0x1e0
 SyS_unlinkat+0x1d/0x30
 entry_SYSCALL_64_fastpath+0x18/0xad
jbd2/sda1-8     D    0    81      2 0x00000000   
Call Trace:
 __schedule+0x295/0x7c0
 ? bit_wait+0x50/0x50
 schedule+0x31/0x80
 io_schedule+0x11/0x40
 bit_wait_io+0xc/0x50
 __wait_on_bit+0x53/0x80
 ? bit_wait+0x50/0x50
 out_of_line_wait_on_bit+0x6e/0x80
 ? autoremove_wake_function+0x30/0x30
 __wait_on_buffer+0x2d/0x30
 jbd2_journal_commit_transaction+0xe6a/0x1700
 kjournald2+0xc8/0x270
 ? kjournald2+0xc8/0x270
 ? wake_atomic_t_function+0x50/0x50
 kthread+0xfe/0x130
 ? commit_timeout+0x10/0x10
 ? kthread_create_on_node+0x40/0x40
 ret_from_fork+0x27/0x40
[ more processes follow, some different tracebacks ]
