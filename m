From: Jan Kara <jack@suse.cz>
Subject: Re: ext4: BUG: scheduling while atomic in ext4_commit_super
Date: Wed, 10 Feb 2016 14:57:48 +0100
Message-ID: <20160210135748.GH12245@quack.suse.cz>
References: <CACT4Y+Y5MveKSQ0Yywdcfa8M+cVPAEXRTiaFGM-ajo_x_pTWHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y5MveKSQ0Yywdcfa8M+cVPAEXRTiaFGM-ajo_x_pTWHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 24-01-16 17:48:00, Dmitry Vyukov wrote:
> Hello,
> 
> I've hit the following BUG while running syzkaller fuzzer:
> 
> JBD2: Spotted dirty metadata buffer (dev = sda, blocknr = 1). There's
> a risk of filesystem corruption in case of system crash.
> EXT4-fs error (device sda): ext4_init_block_bitmap:194: comm
> kworker/u10:2: Checksum bad for group 3
> BUG: sleeping function called from invalid context at
> include/linux/buffer_head.h:354
> in_atomic(): 1, irqs_disabled(): 0, pid: 20922, name: kworker/u10:2
> INFO: lockdep is turned off.
> CPU: 3 PID: 20922 Comm: kworker/u10:2 Tainted: G        W       4.4.0+ #276
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> Workqueue: writeback wb_workfn (flush-8:0)
>  00000000ffffffff ffff8800608ded00 ffffffff82999e2d ffff880067570000
>  00000000000051ba 0000000000000000 ffff8800608ded28 ffffffff813cc25b
>  ffff880067570000 ffffffff864a4ba0 0000000000000162 ffff8800608ded68
> Call Trace:
>  [<     inline     >] __dump_stack lib/dump_stack.c:15
>  [<ffffffff82999e2d>] dump_stack+0x6f/0xa2 lib/dump_stack.c:50
>  [<ffffffff813cc25b>] ___might_sleep+0x27b/0x3a0 kernel/sched/core.c:7703
>  [<ffffffff813cc410>] __might_sleep+0x90/0x1a0 kernel/sched/core.c:7665
>  [<     inline     >] lock_buffer include/linux/buffer_head.h:354
>  [<ffffffff8186b353>] __sync_dirty_buffer+0x63/0x270 fs/buffer.c:3129
>  [<ffffffff81acb8b3>] ext4_commit_super+0x713/0xa80 fs/ext4/super.c:4333
>  [<     inline     >] save_error_info fs/ext4/super.c:316
>  [<ffffffff81acc547>] __ext4_error+0xe7/0x1d0 fs/ext4/super.c:419
>  [<     inline     >] ext4_init_block_bitmap fs/ext4/balloc.c:194

Yeah, we call ext4_error() from inappropriate place. Thanks for reporting
this. I'll send a fix in a moment.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
