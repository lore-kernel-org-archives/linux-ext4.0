From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING in ext4_set_page_dirty
Date: Thu, 19 Apr 2018 18:08:07 +0200
Message-ID: <20180419160807.z4emwbb4rm62phrq@quack2.suse.cz>
References: <089e0825cec8180a2b0568c4ee1d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tytso@mit.edu
To: syzbot <syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <089e0825cec8180a2b0568c4ee1d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

This is a known problem I was speaking about here [1]. It is a generic
mm/fs problem but there's no solution to it yet. We'll discuss it at LSF/MM
next week so after that we may have some solution...

								Honza

[1] https://www.spinics.net/lists/linux-xfs/msg14468.html

On Sun 01-04-18 01:05:00, syzbot wrote:
> syzbot hit the following crash on upstream commit
> 10b84daddbec72c6b440216a69de9a9605127f7a (Sat Mar 31 17:59:00 2018 +0000)
> Merge branch 'perf-urgent-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> syzbot dashboard link:
> https://syzkaller.appspot.com/bug?extid=9a44753ac327c557796a
> 
> So far this crash happened 3 times on upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output:
> https://syzkaller.appspot.com/x/log.txt?id=5118663967375360
> Kernel config:
> https://syzkaller.appspot.com/x/.config?id=-2760467897697295172
> compiler: gcc (GCC) 7.1.1 20170620
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> WARNING: CPU: 0 PID: 7377 at fs/ext4/inode.c:3895
> ext4_set_page_dirty+0x242/0x2b0 fs/ext4/inode.c:3895
> Kernel panic - not syncing: panic_on_warn set ...
> 
> CPU: 0 PID: 7377 Comm: syz-executor1 Not tainted 4.16.0-rc7+ #9
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  panic+0x1e4/0x41c kernel/panic.c:183
>  __warn+0x1dc/0x200 kernel/panic.c:547
>  report_bug+0x1f4/0x2b0 lib/bug.c:186
>  fixup_bug.part.10+0x37/0x80 arch/x86/kernel/traps.c:178
>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
> RIP: 0010:ext4_set_page_dirty+0x242/0x2b0 fs/ext4/inode.c:3895
> RSP: 0000:ffff88018b725df0 EFLAGS: 00010216
> RAX: 0000000000040000 RBX: ffffea0006713040 RCX: ffffffff81ee1072
> RDX: 0000000000002ee2 RSI: ffffc900074f3000 RDI: ffffea0006713040
> RBP: ffff88018b725ec0 R08: 1ffff100316e4c1c R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff100316e4bbf
> R13: ffffea0006713040 R14: ffff88018b725e98 R15: ffffea0006713060
>  set_page_dirty+0x2c5/0x5d0 mm/page-writeback.c:2565
>  set_page_dirty_lock+0xf2/0x160 mm/page-writeback.c:2590
>  dio_bio_complete+0x514/0x750 fs/direct-io.c:560
>  dio_await_completion fs/direct-io.c:581 [inline]
>  do_blockdev_direct_IO+0x7270/0xc960 fs/direct-io.c:1392
>  __blockdev_direct_IO+0x9d/0xd0 fs/direct-io.c:1421
>  ext4_direct_IO_read fs/ext4/inode.c:3830 [inline]
>  ext4_direct_IO+0xfe5/0x1980 fs/ext4/inode.c:3866
>  generic_file_read_iter+0x4cc/0x28e0 mm/filemap.c:2343
>  ext4_file_read_iter+0x113/0x160 fs/ext4/file.c:77
>  call_read_iter include/linux/fs.h:1776 [inline]
>  new_sync_read fs/read_write.c:401 [inline]
>  __vfs_read+0x6a7/0xa00 fs/read_write.c:413
>  vfs_read+0x11e/0x350 fs/read_write.c:447
>  SYSC_pread64 fs/read_write.c:611 [inline]
>  SyS_pread64+0x15b/0x190 fs/read_write.c:598
>  do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x454e79
> RSP: 002b:00007feb4557bc68 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
> RAX: ffffffffffffffda RBX: 00007feb4557c6d4 RCX: 0000000000454e79
> RDX: 00000000ffffff72 RSI: 0000000020003c00 RDI: 0000000000000018
> RBP: 000000000072bea0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 000000000000046d R14: 00000000006f8ad8 R15: 0000000000000000
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
