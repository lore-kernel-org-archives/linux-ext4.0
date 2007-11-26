From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.24-rc3-$SHA1: kernel BUG at fs/jbd/checkpoint.c:683!
Date: Mon, 26 Nov 2007 20:04:05 +0100
Message-ID: <20071126190405.GB5647@atrey.karlin.mff.cuni.cz>
References: <20071126055925.GC1726@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXKZTEG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Nov 2007 14:04:06 -0500
Content-Disposition: inline
In-Reply-To: <20071126055925.GC1726@martell.zuzino.mipt.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> In a desperate attempt to screw up /proc one more time, I added some
> proc fixes, wrote test module which creates and removes simple proc
> file, then ran a) modprobe/rmmod loop, b) cat /proc/foo/bar loop,
> c) LTP loop. So far so good -- survived overnight run.
> 
> While rebooting into new kernel, kernel died:
> 
> [56400.857832] kernel BUG at fs/jbd/checkpoint.c:683!
> [56400.857911] invalid opcode: 0000 [1] PREEMPT SMP 
> [56400.857996] CPU 0 
> [56400.858059] Modules linked in: foo
> [56400.858138] Pid: 392, comm: kjournald Not tainted 2.6.24-rc3-proc #11
> [56400.858227] RIP: 0010:[<ffffffff802cbf10>]  [<ffffffff802cbf10>] __journal_drop_transaction+0x110/0x120
> [56400.858380] RSP: 0000:ffff81017f30dd58  EFLAGS: 00010286
> [56400.858462] RAX: ffff81012ab9f210 RBX: ffff81017f336cd8 RCX: ffff81017fcbbe48
> [56400.858555] RDX: ffff81012ab9f210 RSI: ffff810110eeb318 RDI: ffff81017f336cd8
> [56400.858648] RBP: ffff81017aa8a2a0 R08: 0000000000000000 R09: ffff81017aa8a4f8
> [56400.858741] R10: 0000000000000001 R11: ffffffff8021b220 R12: ffff81017aa8a2a0
> [56400.858834] R13: ffff81017aa8a2a0 R14: ffff81017f30ddbc R15: ffff81017f30ddbc
> [56400.858927] FS:  0000000000000000(0000) GS:ffffffff804ea000(0000) knlGS:0000000000000000
> [56400.859070] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [56400.859157] CR2: 0000000000437c50 CR3: 0000000104dae000 CR4: 00000000000006e0
> [56400.859250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [56400.859343] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [56400.859436] Process kjournald (pid: 392, threadinfo ffff81017f30c000, task ffff81017fcc8ec0)
> [56400.859581] Stack:  ffffffff802cbf7a ffff81016f795c60 ffffffff802cc0a8 0000000000000000
> [56400.859734]  ffff810110eeb318 ffff81012ab9f210 0000000000000001 ffff810117e4da50
> [56400.859881]  ffff81017f30ddbc ffff81017f336e3c ffffffff802cca0b ffff810117e4da50
> [56400.859979] Call Trace:
> [56400.860093]  [<ffffffff802cbf7a>] __journal_remove_checkpoint+0x5a/0xb0
> [56400.860183]  [<ffffffff802cc0a8>] journal_clean_one_cp_list+0xd8/0x170
> [56400.860273]  [<ffffffff802cca0b>] __journal_clean_checkpoint_list+0x4b/0xa0
> [56400.860370]  [<ffffffff802ca6ed>] journal_commit_transaction+0x21d/0x1110
> [56400.860462]  [<ffffffff80230984>] lock_timer_base+0x34/0x70
> [56400.860546]  [<ffffffff80230a13>] try_to_del_timer_sync+0x53/0x60
> [56400.860633]  [<ffffffff802cee1f>] kjournald+0xdf/0x240
> [56400.860715]  [<ffffffff8023c3d0>] autoremove_wake_function+0x0/0x30
> [56400.860803]  [<ffffffff802ced40>] kjournald+0x0/0x240
> [56400.860884]  [<ffffffff8023bffb>] kthread+0x4b/0x80
> [56400.860967]  [<ffffffff8020ca38>] child_rip+0xa/0x12
> [56400.861047]  [<ffffffff8023bfb0>] kthread+0x0/0x80
> [56400.861126]  [<ffffffff8020ca2e>] child_rip+0x0/0x12
> [56400.861205] 
> [56400.861262] 
> [56400.861263] Code: 0f 0b eb fe 66 66 66 90 66 66 66 90 66 66 66 90 53 48 8b 77 
> [56400.861546] RIP  [<ffffffff802cbf10>] __journal_drop_transaction+0x110/0x120
> [56400.861642]  RSP <ffff81017f30dd58>
> [56400.862158] Kernel panic - not syncing: Fatal exception
  Thanks for report. It's a bug in JBD code and strangely enough noone
hit it before you :). The problem is that
__journal_clean_checkpoint_list() finds there's a buffer on
transaction's checkpoint list which has already been written. So it
removes and because there are no other buffers there, it tries to free
the transaction as well which is a bug. It should also check that the
transaction is not currently running.
   Now the question is how to properly check this. We should hold
j_state_lock for that but we are holding other locks which rank below
it... Argh. Will have to think about it.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
