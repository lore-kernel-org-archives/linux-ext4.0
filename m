From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [sparc64] ext4 TPC and call trace (process blocked/stuck) on git
 kernel 4.8.0-rc3+
Date: Fri, 21 Apr 2017 19:38:50 +0300
Message-ID: <CADxRZqwMhCe4OrGxSiON=wHg-+hGahiR5rfof8bHZWVUSVW-EA@mail.gmail.com>
References: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: Sparc kernel list <sparclinux@vger.kernel.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CADxRZqyE2HjaXzbv-9ovJM=G18C28tr7pEL8RsUx+9o870jqBg@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 24, 2016 at 11:13 AM, Anatoly Pugachev <matorola@gmail.com> wrote:
> Hello!
>
> Running fstests (xfstests) suite on sparc64 debian sid/unstable with
> linux kernel 4.8.0-rc3+ , I'm getting the following call trace and TPC
> on server console and system logs:


got another hung task (sys)log, but not with xfstests and with some
debug (kernel locks) output (kernel is 4.10.0-git-something). Can
someone knowing kernel have a look and maybe spot something. If not,
thanks anyway and machine still works. Thanks!

Apr 19 19:30:43 landau kernel: INFO: task ostree:107749 blocked for
more than 120 seconds.
Apr 19 19:30:43 landau kernel:       Tainted: G        W
4.10.0-10531-g86292b33d4b7 #77
Apr 19 19:30:43 landau kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 19 19:30:43 landau kernel: ostree          D    0 107749  92509
0x208000103000000
Apr 19 19:30:43 landau kernel: Call Trace:
Apr 19 19:30:43 landau kernel:  [0000000000a8e790] schedule+0x30/0xc0
Apr 19 19:30:43 landau kernel:  [0000000000681798]
wb_wait_for_completion+0x58/0xa0
Apr 19 19:30:43 landau kernel:  [0000000000682048]
__writeback_inodes_sb_nr+0x88/0xc0
Apr 19 19:30:43 landau kernel:  [00000000006820e0] writeback_inodes_sb+0x20/0x40
Apr 19 19:30:43 landau kernel:  [000000000068a5f4] sync_filesystem+0x34/0xc0
Apr 19 19:30:43 landau kernel:  [000000000068a7f8] SyS_syncfs+0x38/0x80
Apr 19 19:30:43 landau kernel:  [0000000000406234] linux_sparc_syscall+0x34/0x44
Apr 19 19:30:43 landau kernel:
                               Showing all locks held in the system:
Apr 19 19:30:43 landau kernel: 2 locks held by khungtaskd/784:
Apr 19 19:30:43 landau kernel:  #0:  (rcu_read_lock){......}, at:
[<000000000054eb80>] watchdog+0x240/0x7e0
Apr 19 19:30:43 landau kernel:  #1:  (tasklist_lock){.+.+..}, at:
[<00000000004d2d04>] debug_show_all_locks+0x64/0x1c0
Apr 19 19:30:43 landau kernel: 1 lock held by in:imklog/1484:
Apr 19 19:30:43 landau kernel:  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<000000000066f8ac>] __fdget_pos+0x4c/0x60
Apr 19 19:30:43 landau kernel: 5 locks held by kworker/u512:0/91935:
Apr 19 19:30:43 landau kernel:  #0:  ("writeback"){.+.+.+}, at:
[<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 19:30:43 landau kernel:  #1:  ((&(&wb->dwork)->work)){+.+.+.},
at: [<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 19:30:43 landau kernel:  #2:
(&sbi->s_journal_flag_rwsem){.+.+.+}, at: [<00000000005c99ac>]
do_writepages+0x2c/0x60
Apr 19 19:30:43 landau kernel:  #3:  (jbd2_handle){++++..}, at:
[<00000000101647c8>] start_this_handle+0x108/0x3e0 [jbd2]
Apr 19 19:30:43 landau kernel:  #4:  (&ei->i_data_sem){++++..}, at:
[<000000001019fb38>] ext4_map_blocks+0x138/0x6a0 [ext4]
Apr 19 19:30:43 landau kernel: 1 lock held by ostree/107749:
Apr 19 19:30:43 landau kernel:  #0:  (&type->s_umount_key#29){++++++},
at: [<000000000068a7f0>] SyS_syncfs+0x30/0x80
Apr 19 19:30:43 landau kernel:
Apr 19 19:30:43 landau kernel: =============================================
Apr 19 20:27:06 landau kernel: INFO: task ostree:73769 blocked for
more than 120 seconds.
Apr 19 20:27:06 landau kernel:       Tainted: G        W
4.10.0-10531-g86292b33d4b7 #77
Apr 19 20:27:06 landau kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 19 20:27:06 landau kernel: ostree          D    0 73769  58526
0x208000100000000
Apr 19 20:27:06 landau kernel: Call Trace:
Apr 19 20:27:06 landau kernel:  [0000000000a8e790] schedule+0x30/0xc0
Apr 19 20:27:06 landau kernel:  [0000000000681798]
wb_wait_for_completion+0x58/0xa0
Apr 19 20:27:06 landau kernel:  [0000000000682048]
__writeback_inodes_sb_nr+0x88/0xc0
Apr 19 20:27:06 landau kernel:  [00000000006820e0] writeback_inodes_sb+0x20/0x40
Apr 19 20:27:06 landau kernel:  [000000000068a5f4] sync_filesystem+0x34/0xc0
Apr 19 20:27:06 landau kernel:  [000000000068a7f8] SyS_syncfs+0x38/0x80
Apr 19 20:27:06 landau kernel:  [0000000000406234] linux_sparc_syscall+0x34/0x44
Apr 19 20:27:06 landau kernel:
                               Showing all locks held in the system:
Apr 19 20:27:06 landau kernel: 2 locks held by khungtaskd/784:
Apr 19 20:27:06 landau kernel:  #0:  (rcu_read_lock){......}, at:
[<000000000054eb80>] watchdog+0x240/0x7e0
Apr 19 20:27:06 landau kernel:  #1:  (tasklist_lock){.+.+..}, at:
[<00000000004d2d04>] debug_show_all_locks+0x64/0x1c0
Apr 19 20:27:06 landau kernel: 1 lock held by in:imklog/1484:
Apr 19 20:27:06 landau kernel:  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<000000000066f8ac>] __fdget_pos+0x4c/0x60
Apr 19 20:27:06 landau kernel: 5 locks held by kworker/u512:3/46184:
Apr 19 20:27:06 landau kernel:  #0:  ("writeback"){.+.+.+}, at:
[<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 20:27:06 landau kernel:  #1:  ((&(&wb->dwork)->work)){+.+.+.},
at: [<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 20:27:06 landau kernel:  #2:
(&sbi->s_journal_flag_rwsem){.+.+.+}, at: [<00000000005c99ac>]
do_writepages+0x2c/0x60
Apr 19 20:27:06 landau kernel:  #3:  (jbd2_handle){++++..}, at:
[<00000000101647c8>] start_this_handle+0x108/0x3e0 [jbd2]
Apr 19 20:27:06 landau kernel:  #4:  (&ei->i_data_sem){++++..}, at:
[<000000001019fb38>] ext4_map_blocks+0x138/0x6a0 [ext4]
Apr 19 20:27:06 landau kernel: 1 lock held by ostree/73769:
Apr 19 20:27:06 landau kernel:  #0:  (&type->s_umount_key#29){++++++},
at: [<000000000068a7f0>] SyS_syncfs+0x30/0x80
Apr 19 20:27:06 landau kernel:
Apr 19 20:27:06 landau kernel: =============================================
Apr 19 20:45:14 landau kernel: INFO: task ostree:146257 blocked for
more than 120 seconds.
Apr 19 20:45:14 landau kernel:       Tainted: G        W
4.10.0-10531-g86292b33d4b7 #77
Apr 19 20:45:14 landau kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 19 20:45:14 landau kernel: ostree          D    0 146257 131005
0x208000100000000
Apr 19 20:45:14 landau kernel: Call Trace:
Apr 19 20:45:14 landau kernel:  [0000000000a8e790] schedule+0x30/0xc0
Apr 19 20:45:14 landau kernel:  [0000000000681798]
wb_wait_for_completion+0x58/0xa0
Apr 19 20:45:14 landau kernel:  [0000000000682048]
__writeback_inodes_sb_nr+0x88/0xc0
Apr 19 20:45:14 landau kernel:  [00000000006820e0] writeback_inodes_sb+0x20/0x40
Apr 19 20:45:14 landau kernel:  [000000000068a5f4] sync_filesystem+0x34/0xc0
Apr 19 20:45:14 landau kernel:  [000000000068a7f8] SyS_syncfs+0x38/0x80
Apr 19 20:45:14 landau kernel:  [0000000000406234] linux_sparc_syscall+0x34/0x44
Apr 19 20:45:14 landau kernel:
                               Showing all locks held in the system:
Apr 19 20:45:14 landau kernel: 2 locks held by khungtaskd/784:
Apr 19 20:45:14 landau kernel:  #0:  (rcu_read_lock){......}, at:
[<000000000054eb80>] watchdog+0x240/0x7e0
Apr 19 20:45:14 landau kernel:  #1:  (tasklist_lock){.+.+..}, at:
[<00000000004d2d04>] debug_show_all_locks+0x64/0x1c0
Apr 19 20:45:14 landau kernel: 1 lock held by in:imklog/1484:
Apr 19 20:45:14 landau kernel:  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<000000000066f8ac>] __fdget_pos+0x4c/0x60
Apr 19 20:45:14 landau kernel: 5 locks held by kworker/u512:0/130949:
Apr 19 20:45:14 landau kernel:  #0:  ("writeback"){.+.+.+}, at:
[<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 20:45:14 landau kernel:  #1:  ((&(&wb->dwork)->work)){+.+.+.},
at: [<000000000048a5b4>] process_one_work+0x174/0x840
Apr 19 20:45:14 landau kernel:  #2:
(&sbi->s_journal_flag_rwsem){.+.+.+}, at: [<00000000005c99ac>]
do_writepages+0x2c/0x60
Apr 19 20:45:14 landau kernel:  #3:  (jbd2_handle){++++..}, at:
[<00000000101647c8>] start_this_handle+0x108/0x3e0 [jbd2]
Apr 19 20:45:14 landau kernel:  #4:  (&ei->i_data_sem){++++..}, at:
[<000000001019fb38>] ext4_map_blocks+0x138/0x6a0 [ext4]
Apr 19 20:45:14 landau kernel: 1 lock held by ostree/146257:
Apr 19 20:45:14 landau kernel:  #0:  (&type->s_umount_key#29){++++++},
at: [<000000000068a7f0>] SyS_syncfs+0x30/0x80
Apr 19 20:45:14 landau kernel:
Apr 19 20:45:14 landau kernel: =============================================
