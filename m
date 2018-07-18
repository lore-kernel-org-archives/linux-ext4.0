From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: INFO: task hung in ext4_direct_IO
Date: Wed, 18 Jul 2018 13:48:44 +0200
Message-ID: <CACT4Y+ajax9tQefJnTttZkThKxiuQ+rAZ_DO1yPkYDMGcE-uNA@mail.gmail.com>
References: <000000000000a88a2e056c2b67a0@google.com> <5a44c756-2056-97cd-48e2-1f1585eb231e@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+45843822635038f93354@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5a44c756-2056-97cd-48e2-1f1585eb231e@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 14, 2018 at 5:11 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> On 2018/05/14 23:36, syzbot wrote:
>> Call Trace:
>>  context_switch kernel/sched/core.c:2859 [inline]
>>  __schedule+0x801/0x1e30 kernel/sched/core.c:3501
>>  schedule+0xef/0x430 kernel/sched/core.c:3545
>>  __rwsem_down_read_failed_common kernel/locking/rwsem-xadd.c:269 [inline]
>>  rwsem_down_read_failed+0x350/0x5e0 kernel/locking/rwsem-xadd.c:286
>>  call_rwsem_down_read_failed+0x18/0x30 arch/x86/lib/rwsem.S:94
>>  __down_read arch/x86/include/asm/rwsem.h:83 [inline]
>>  down_read+0xbd/0x1b0 kernel/locking/rwsem.c:26
>>  inode_lock_shared include/linux/fs.h:723 [inline]
>>  ext4_direct_IO_read fs/ext4/inode.c:3828 [inline]
>>  ext4_direct_IO+0x653/0x2110 fs/ext4/inode.c:3865
>>  generic_file_read_iter+0x510/0x2f00 mm/filemap.c:2341
>>  ext4_file_read_iter+0x18b/0x3c0 fs/ext4/file.c:77
>>  call_read_iter include/linux/fs.h:1778 [inline]
>>  generic_file_splice_read+0x552/0x910 fs/splice.c:307
>>  do_splice_to+0x12e/0x190 fs/splice.c:880
>>  splice_direct_to_actor+0x268/0x8d0 fs/splice.c:952
>>  do_splice_direct+0x2cc/0x400 fs/splice.c:1061
>>  do_sendfile+0x60f/0xe00 fs/read_write.c:1440
>>  __do_sys_sendfile64 fs/read_write.c:1495 [inline]
>>  __se_sys_sendfile64 fs/read_write.c:1487 [inline]
>>  __x64_sys_sendfile64+0x155/0x240 fs/read_write.c:1487
>>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> This resembles
>
> Call Trace:
>  context_switch kernel/sched/core.c:2848 [inline]
>  __schedule+0x801/0x1e30 kernel/sched/core.c:3490
>  schedule+0xef/0x430 kernel/sched/core.c:3549
>  __rwsem_down_write_failed_common+0x919/0x15d0 kernel/locking/rwsem-xadd.c:566
>  rwsem_down_write_failed+0xe/0x10 kernel/locking/rwsem-xadd.c:595
>  call_rwsem_down_write_failed+0x17/0x30 arch/x86/lib/rwsem.S:117
>  __down_write arch/x86/include/asm/rwsem.h:142 [inline]
>  down_write+0xa2/0x120 kernel/locking/rwsem.c:72
>  inode_lock include/linux/fs.h:713 [inline]
>  ext4_file_write_iter+0x303/0x1420 fs/ext4/file.c:235
>  call_write_iter include/linux/fs.h:1784 [inline]
>  new_sync_write fs/read_write.c:474 [inline]
>  __vfs_write+0x64d/0x960 fs/read_write.c:487
>  vfs_write+0x1f8/0x560 fs/read_write.c:549
>  ksys_pwrite64+0x174/0x1a0 fs/read_write.c:652
>  __do_sys_pwrite64 fs/read_write.c:662 [inline]
>  __se_sys_pwrite64 fs/read_write.c:659 [inline]
>  __x64_sys_pwrite64+0x97/0xf0 fs/read_write.c:659
>  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> in the report below.
>
>   INFO: task hung in ext4_file_write_iter
>   https://syzkaller.appspot.com/bug?id=c7370ffdecb4c7c7a24a50e17acaf102850d43ab
>
> But I have no idea why usual file write causes problems.
>
> Since there is LOOP_CHANGE_FD request in the console output, maybe it is better to
> try 170785a9cc72e8e1 ("loop: add recursion validation to LOOP_CHANGE_FD") now
> and see whether it helps?


Let's do:

#syz dup: INFO: task hung in ext4_file_write_iter

just to clean the dashboard a bit.
