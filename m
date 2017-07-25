From: Jan Kara <jack@suse.cz>
Subject: Re: bfq/ext4 disk IO hangs forever on resume
Date: Tue, 25 Jul 2017 10:51:28 +0200
Message-ID: <20170725085128.GA20040@quack2.suse.cz>
References: <20170625230756.68b4de21.alex_y_xu@yahoo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Paolo Valente <paolo.valente@linaro.org>,
        linux-block@vger.kernel.org
To: Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170625230756.68b4de21.alex_y_xu@yahoo.ca>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Sun 25-06-17 23:07:56, Alex Xu wrote:
> I get hangs when resuming when using bfq-mq with ext4 on 4.12-rc6+
> (currently a4fd8b3accf43d407472e34403d4b0a4df5c0e71).
> 
> Steps to reproduce:
> 1. boot computer
> 2. systemctl suspend
> 3. wait few seconds
> 4. press power button
> 5. type "ls" into console or SSH or do anything that does disk IO
> 
> Expected results:
> Command is executed.
> 
> Actual results:
> Command hangs.
> 
> lockdep has no comments, but sysrq-d shows that i_mutex_dir_key and
> jbd2_handle are held by multiple processes, leading me to suspect that
> ext4 is at least partially involved. [0]

Can you still reproduce this?

> sysrq-w lists many blocked processes [1]
> 
> This happens consistently, every time I resume the system from
> suspend-to-RAM using this configuration. Switching to noop IO scheduler
> makes it stop happening. I haven't tried switching filesystems yet.

The two stacktraces that you've pasted show that we are waiting for buffer
lock - likely we have submitted the buffer for IO and are waiting for it to
complete. Together with the fact that switching to NOOP fixes the problem I
somewhat suspect that IO scheduler somehow fails to ever complete some IO -
added relevant people to CC.

Anyway if you can still reproduce, it would be good to get full output from
sysrq-w so that we can confirm that everything is blocked on waiting for IO
to complete.

> I can do more debugging (enable KASAN or whatever), but usually when I
> bother doing that I find someone has already sent a patch for the issue.

								Honza

> [0]
> 
> 4 locks held by systemd/384:                                                                                                                                                                                                                 
>  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811b0e5f>] mnt_want_write+0x1f/0x50
>  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff8119b7ce>] do_rmdir+0x15e/0x1e0
>  #2:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff81195ee0>] vfs_rmdir+0x50/0x130
>  #3:  (jbd2_handle){++++..}, at: [<ffffffff8124f17f>] start_this_handle+0xff/0x430
> 4 locks held by syncthing/279: 
>  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff811ade1e>] __fdget_pos+0x3e/0x50
>  #1:  (sb_writers#3){.+.+.+}, at: [<ffffffff8118b04c>] vfs_write+0x17c/0x1d0
>  #2:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff81217977>] ext4_file_write_iter+0x57/0x350
>  #3:  (jbd2_handle){++++..}, at: [<ffffffff8124f17f>] start_this_handle+0xff/0x430
> 2 locks held by zsh/238:
>  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff816fbeaf>] ldsem_down_read+0x1f/0x30
>  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff8134fbb0>] n_tty_read+0xb0/0x8b0
> 2 locks held by sddm-greeter/267:
>  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811b0e5f>] mnt_want_write+0x1f/0x50
>  #1:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff8119a698>] path_openat+0x2d8/0xa10
> 2 locks held by kworker/u16:28/330:
>  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810a1ef3>] process_one_work+0x1c3/0x420
>  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810a1ef3>] process_one_work+0x1c3/0x420
> 1 lock held by zsh/382:
>  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81192570>] prepare_bprm_creds+0x30/0x70
> 
> [1]
> 
>   task                        PC stack   pid father
> systemd         D    0   384      0 0x00000000   
> Call Trace:
>  __schedule+0x295/0x7c0
>  ? bit_wait+0x50/0x50
>  ? bit_wait+0x50/0x50
>  schedule+0x31/0x80
>  io_schedule+0x11/0x40
>  bit_wait_io+0xc/0x50
>  __wait_on_bit+0x53/0x80
>  ? bit_wait+0x50/0x50
>  out_of_line_wait_on_bit+0x6e/0x80
>  ? autoremove_wake_function+0x30/0x30
>  do_get_write_access+0x20b/0x420
>  jbd2_journal_get_write_access+0x2c/0x60
>  __ext4_journal_get_write_access+0x55/0xa0
>  ext4_delete_entry+0x8c/0x140
>  ? __ext4_journal_start_sb+0x4e/0xa0
>  ext4_rmdir+0x114/0x250
>  vfs_rmdir+0x6e/0x130
>  do_rmdir+0x1a3/0x1e0
>  SyS_unlinkat+0x1d/0x30
>  entry_SYSCALL_64_fastpath+0x18/0xad
> jbd2/sda1-8     D    0    81      2 0x00000000   
> Call Trace:
>  __schedule+0x295/0x7c0
>  ? bit_wait+0x50/0x50
>  schedule+0x31/0x80
>  io_schedule+0x11/0x40
>  bit_wait_io+0xc/0x50
>  __wait_on_bit+0x53/0x80
>  ? bit_wait+0x50/0x50
>  out_of_line_wait_on_bit+0x6e/0x80
>  ? autoremove_wake_function+0x30/0x30
>  __wait_on_buffer+0x2d/0x30
>  jbd2_journal_commit_transaction+0xe6a/0x1700
>  kjournald2+0xc8/0x270
>  ? kjournald2+0xc8/0x270
>  ? wake_atomic_t_function+0x50/0x50
>  kthread+0xfe/0x130
>  ? commit_timeout+0x10/0x10
>  ? kthread_create_on_node+0x40/0x40
>  ret_from_fork+0x27/0x40
> [ more processes follow, some different tracebacks ]
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
