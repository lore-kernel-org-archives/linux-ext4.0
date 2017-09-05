From: Jan Kara <jack@suse.cz>
Subject: Re: workqueue threads ->journal_info buggery
Date: Tue, 5 Sep 2017 13:26:42 +0200
Message-ID: <20170905112642.GB10617@quack2.suse.cz>
References: <a3c8996b-cde2-809c-5ff6-bfab104dd0d5@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
To: Nikolay Borisov <nborisov@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a3c8996b-cde2-809c-5ff6-bfab104dd0d5@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

On Tue 05-09-17 11:51:44, Nikolay Borisov wrote:
> I've hit the following problems under memory-heavy workload conditions: 
> 
> First is a BUG_ON : J_ASSERT(journal_current_handle() == handle);                           
> 
> [   64.261793] kernel BUG at fs/jbd2/transaction.c:1644!
> [   64.263894] invalid opcode: 0000 [#1] SMP
> [   64.266187] Modules linked in:
> [   64.267472] CPU: 1 PID: 542 Comm: kworker/u12:6 Not tainted 4.12.0-nbor #135
> [   64.269941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   64.272374] Workqueue: writeback wb_workfn (flush-254:0)
> [   64.273862] task: ffff88001c37b880 task.stack: ffff880018ac8000
> [   64.275580] RIP: 0010:jbd2_journal_stop+0x375/0x4d0
> [   64.276704] RSP: 0000:ffff880018acb990 EFLAGS: 00010286
> [   64.278708] RAX: ffff88001c37b880 RBX: ffff88001e83c000 RCX: ffff88001c4f8800
> [   64.280499] RDX: ffff88001e83c000 RSI: 0000000000000b26 RDI: ffff88001e83c000
> [   64.282262] RBP: ffff880018acba10 R08: ffff880019ec5888 R09: 0000000000000000
> [   64.284111] R10: 0000000000000000 R11: ffffffff81283f8f R12: ffff880018a1a140
> [   64.285553] R13: ffff88001c4f8800 R14: ffff88001c47d000 R15: ffff880018aa01f0
> [   64.286337] FS:  0000000000000000(0000) GS:ffff88001fc40000(0000) knlGS:0000000000000000
> [   64.287671] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   64.288568] CR2: 0000000000421ac0 CR3: 000000001ae83000 CR4: 00000000000006a0
> [   64.289468] Call Trace:
> [   64.289748]  ? __ext4_journal_get_write_access+0x67/0xc0
> [   64.290330]  ? ext4_writepages+0xec6/0x1200
> [   64.290786]  __ext4_journal_stop+0x3c/0xa0
> [   64.291233]  ext4_writepages+0x8b2/0x1200
> [   64.291682]  ? writeback_sb_inodes+0x11f/0x5c0
> [   64.292174]  do_writepages+0x1c/0x80
> [   64.292572]  ? do_writepages+0x1c/0x80
> [   64.292985]  __writeback_single_inode+0x61/0x760
> [   64.293575]  writeback_sb_inodes+0x28d/0x5c0
> [   64.294192]  __writeback_inodes_wb+0x92/0xc0
> [   64.294777]  wb_writeback+0x3e9/0x560
> [   64.295241]  wb_workfn+0x9a/0x5d0
> [   64.295977]  ? wb_workfn+0x9a/0x5d0
> [   64.296788]  ? process_one_work+0x15c/0x620
> [   64.297971]  process_one_work+0x1d9/0x620
> [   64.298969]  worker_thread+0x4e/0x3b0
> [   64.299684]  kthread+0x113/0x150
> [   64.300287]  ? process_one_work+0x620/0x620
> [   64.301145]  ? kthread_create_on_node+0x40/0x40
> [   64.301953]  ret_from_fork+0x2a/0x40
> [   64.302572] Code: dd ff 41 8b 45 60 85 c0 0f 84 29 fe ff ff 49 8d bd 00 01 00 00 31 c9 ba 01 00 00 00 be 03 00 00 00 e8 90 c1 dd ff e9 0c fe ff ff <0f> 0b 44 89 fe 4c 89 ef e8 ce 83 00 00 89 45 c4 e9 18 fe ff ff 
> [   64.305997] RIP: jbd2_journal_stop+0x375/0x4d0 RSP: ffff880018acb990
> [   64.307037] ---[ end trace ec3f7cbd6e733faf ]---
> 
> I consulted with Jan his opinion is that this is due to ->journal_info 
> in workqueue threads gets modified while the work was running.  

Sorry, this was a false alarm. Nikolai eventually hit also traces that were
not from workqueue code and eventually we've tracked down the problem to
his btrfs swapfile patches which were overwriting current->journal_info in
the swapout path...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
