From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 crash? on rsyn action
Date: Tue, 12 Jan 2010 20:44:14 +0100
Message-ID: <20100112194414.GB24833@atrey.karlin.mff.cuni.cz>
References: <4B4B8AB8.5040907@zackbummfertig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Marko Weber <weber@zackbummfertig.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0ALToP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 14:44:15 -0500
Content-Disposition: inline
In-Reply-To: <4B4B8AB8.5040907@zackbummfertig.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  Thanks for the report.

> i had an crash on moving data with rsync on my system.
> from system hdd (xfs) i moved with rsync data to my raid5 array (ext4).
> nearly at end of rsync the opration hang.
> i dont know if this is a crash.
  It's not a crash but it might be a deadlock. But from the traces it's
not quite clear. There is just task jbd2/md0-8 waiting in
jbd2_journal_commit_transaction. Other tasks (spindownd and rsync) are
just waiting for commit to finish. If you can send your vmlinux file, we
can find out where exactly in jbd2_journal_commit_transaction we wait.
If we wait for IO, everything is fine and we should eventually resume.
If we wait for someone to drop handle to a transaction, it's probably a
deadlock...

								Honza

> used kernel on the system 2.6.32.3
> 
> in /var/log/messages i found this =
> 
> Jan 11 19:38:51 zagreb kernel: INFO: task jbd2/md0-8:5435 blocked for 
> more than 120 seconds.
> Jan 11 19:38:51 zagreb kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 11 19:38:51 zagreb kernel: jbd2/md0-8    D ffff88022e3f7d80     0  
> 5435      2 0x00000000
> Jan 11 19:38:51 zagreb kernel: ffff88022f87a870 0000000000000046 
> 0000000000000000 ffff88022bc43e24
> Jan 11 19:38:51 zagreb kernel: 000000022bc43cb0 ffff88022bc43e10 
> 000000000000e2e0 ffff88022bc43fd8
> Jan 11 19:38:51 zagreb kernel: 0000000000012000 ffff88022bc43fd8 
> 0000000000012000 ffff88022fad4140
> Jan 11 19:38:51 zagreb kernel: Call Trace:
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81026fd0>] ? __switch_to+0xd0/0x297
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8114d0fe>] ? 
> jbd2_journal_commit_transaction+0x17d/0xf9f
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8105676f>] ? 
> finish_task_switch+0x3a/0xb4
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d5fd>] ? 
> autoremove_wake_function+0x0/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810641e5>] ? 
> lock_timer_base+0x26/0x4b
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81064274>] ? 
> try_to_del_timer_sync+0x6a/0x73
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81150ea2>] ? kjournald2+0xbd/0x1dd
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d5fd>] ? 
> autoremove_wake_function+0x0/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81150de5>] ? kjournald2+0x0/0x1dd
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d38f>] ? kthread+0x79/0x81
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8102942a>] ? child_rip+0xa/0x20
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d316>] ? kthread+0x0/0x81
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81029420>] ? child_rip+0x0/0x20
> Jan 11 19:38:51 zagreb kernel: INFO: task spindownd:9924 blocked for 
> more than 120 seconds.
> Jan 11 19:38:51 zagreb kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 11 19:38:51 zagreb kernel: spindownd     D ffff880224e01e80     0  
> 9924      1 0x00000000
> Jan 11 19:38:51 zagreb kernel: ffffffff816828a0 0000000000000082 
> 0000000000000000 ffff88022e6fd000
> Jan 11 19:38:51 zagreb kernel: 0000000000000292 ffff88022bc52f28 
> 000000000000e2e0 ffff880224e01fd8
> Jan 11 19:38:51 zagreb kernel: 0000000000012000 ffff880224e01fd8 
> 0000000000012000 ffff88022e2c9830
> Jan 11 19:38:51 zagreb kernel: Call Trace:
> Jan 11 19:38:51 zagreb kernel: [<ffffffff811508ae>] ? 
> jbd2_log_wait_commit+0xbe/0x110
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d5fd>] ? 
> autoremove_wake_function+0x0/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8112f32e>] ? ext4_sync_fs+0x44/0x4d
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810fcaa1>] ? 
> sync_quota_sb+0x45/0xf6
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810d952a>] ? 
> __sync_filesystem+0x43/0x70
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810d95f0>] ? 
> sync_filesystems+0x99/0xe1
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810d967d>] ? sys_sync+0x1c/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81028442>] ? 
> system_call_fastpath+0x16/0x1b
> Jan 11 19:38:51 zagreb kernel: INFO: task rsync:23457 blocked for more 
> than 120 seconds.
> Jan 11 19:38:51 zagreb kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 11 19:38:51 zagreb kernel: rsync         D ffff88022faa3824     0 
> 23457      1 0x00000004
> Jan 11 19:38:51 zagreb kernel: ffff88022f8a67b0 0000000000000082 
> 0000000000000000 0000000000000001
> Jan 11 19:38:51 zagreb kernel: 0000000063400074 0000000000000001 
> 000000000000e2e0 ffff880207cb5fd8
> Jan 11 19:38:51 zagreb kernel: 0000000000012000 ffff880207cb5fd8 
> 0000000000012000 ffff8801de07d100
> Jan 11 19:38:51 zagreb kernel: Call Trace:
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81139da9>] ? 
> __ext4_handle_dirty_metadata+0xc9/0xd4
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8114cb5c>] ? 
> start_this_handle+0x2d9/0x3a1
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d5fd>] ? 
> autoremove_wake_function+0x0/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8114cd82>] ? 
> jbd2_journal_start+0x96/0xc6
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81129c48>] ? 
> ext4_da_write_begin+0xe2/0x1ed
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81095953>] ? 
> generic_file_buffered_write+0x118/0x278
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81095f45>] ? 
> __generic_file_aio_write+0x340/0x374
> Jan 11 19:38:51 zagreb kernel: [<ffffffff813eec37>] ? 
> sock_aio_read+0x109/0x11d
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81095fd2>] ? 
> generic_file_aio_write+0x59/0x9f
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810bc2f6>] ? 
> do_sync_write+0xce/0x113
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810270ad>] ? 
> __switch_to+0x1ad/0x297
> Jan 11 19:38:51 zagreb kernel: [<ffffffff8106d5fd>] ? 
> autoremove_wake_function+0x0/0x2e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810732a2>] ? ktime_get_ts+0x68/0xb2
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810c931a>] ? 
> poll_select_copy_remaining+0xd0/0xf3
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810bcc05>] ? vfs_write+0xad/0x149
> Jan 11 19:38:51 zagreb kernel: [<ffffffff810bcd5d>] ? sys_write+0x45/0x6e
> Jan 11 19:38:51 zagreb kernel: [<ffffffff81028442>] ? 
> system_call_fastpath+0x16/0x1b
> Jan 11 19:39:01 zagreb cron[23909]: (root) CMD 
> (/usr/local/mrourmon/bin/omupdate.sh)
> Jan 11 19:39:47 zagreb su[24028]: Successful su for root by weber
> Jan 11 19:39:47 zagreb su[24028]: + pts/4 weber:root
> Jan 11 19:39:47 zagreb su[24028]: pam_unix(su:session): session opened 
> for user root by weber(uid=1000)
> Jan 11 19:40:01 zagreb cron[24042]: (root) CMD 
> (/usr/local/mrourmon/bin/omupdate.sh)
> Jan 11 19:40:01 zagreb cron[24043]: (root) CMD (test -x 
> /usr/sbin/run-crons && /usr/sbin/run-crons )
> Jan 11 19:40:48 zagreb su[22526]: pam_unix(su:session): session closed 
> for user root
> Jan 11 19:40:51 zagreb kernel: INFO: task shutdown:23846 blocked for 
> more than 120 seconds.
> Jan 11 19:40:51 zagreb kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 11 19:40:51 zagreb kernel: shutdown      D ffffffffffffffff     0 
> 23846  23580 0x00000000
> Jan 11 19:40:51 zagreb kernel: ffff880224d0d040 0000000000000086 
> 0000000000012000 ffff8801f2e67a80
> Jan 11 19:40:51 zagreb kernel: 0000000000000000 ffff8801f2e67a80 
> 000000000000e2e0 ffff88010000bfd8
> Jan 11 19:40:51 zagreb kernel: 0000000000012000 ffff88010000bfd8 
> 0000000000012000 ffff8802291a40c0
> Jan 11 19:40:51 zagreb kernel: Call Trace:
> Jan 11 19:40:51 zagreb kernel: [<ffffffff8104edfc>] ? 
> check_preempt_wakeup+0x186/0x215
> Jan 11 19:40:51 zagreb kernel: [<ffffffff814aa198>] ? 
> __mutex_lock_slowpath+0xd6/0x121
> Jan 11 19:40:51 zagreb kernel: [<ffffffff814aa041>] ? mutex_lock+0x12/0x28
> Jan 11 19:40:51 zagreb kernel: [<ffffffff810d956a>] ? 
> sync_filesystems+0x13/0xe1
> Jan 11 19:40:51 zagreb kernel: [<ffffffff810d9673>] ? sys_sync+0x12/0x2e
> Jan 11 19:40:51 zagreb kernel: [<ffffffff81028442>] ? 
> system_call_fastpath+0x16/0x1b
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
