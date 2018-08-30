From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: stack-out-of-bounds Read in __schedule
Date: Wed, 29 Aug 2018 21:11:20 -0700
Message-ID: <CACT4Y+a2bwVvDRfL=wg=5bnOv6S7RrJYoh4ygaizqVm3JpNu1A@mail.gmail.com>
References: <000000000000fef39305748083ae@google.com> <20180829134620.GD7369@quack2.suse.cz>
 <CAG_fn=VMcHaGrFs_YvtBttmfuz8Rr1C_dfmKRibvPrbqeKFGCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Jan Kara <jack@suse.cz>,
        syzbot+45a34334c61a8ecf661d@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>
To: Alexander Potapenko <glider@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG_fn=VMcHaGrFs_YvtBttmfuz8Rr1C_dfmKRibvPrbqeKFGCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 29, 2018 at 7:03 AM, 'Alexander Potapenko' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> On Wed, Aug 29, 2018 at 3:46 PM Jan Kara <jack@suse.cz> wrote:
>>
>> On Tue 28-08-18 08:30:02, syzbot wrote:
>> > Hello,
>> >
>> > syzbot found the following crash on:
>> >
>> > HEAD commit:    5b394b2ddf03 Linux 4.19-rc1
>> > git tree:       upstream
>> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14f4d8e140=
0000
>> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D49927b422d=
cf0b29
>> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D45a34334c61a=
8ecf661d
>> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13127e5a=
400000
>> >
>> > IMPORTANT: if you fix the bug, please add the following tag to the com=
mit:
>> > Reported-by: syzbot+45a34334c61a8ecf661d@syzkaller.appspotmail.com
>> >
>> > IPv6: ADDRCONF(NETDEV_UP): veth1: link is not ready
>> > IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
>> > IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
>> > 8021q: adding VLAN 0 to HW filter on device team0
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > BUG: KASAN: stack-out-of-bounds in schedule_debug kernel/sched/core.c:=
3285
>> > [inline]
>> > BUG: KASAN: stack-out-of-bounds in __schedule+0x1977/0x1df0
>> > kernel/sched/core.c:3395
>> > Read of size 8 at addr ffff8801ad090000 by task syz-executor0/4718
>>
>> Weird, can you please help me decipher this? So here KASAN complains abo=
ut
>> wrong memory access in the scheduler.


This looks like a result of a previous bad silent memory corruption.

The KASAN report says there is a stack out-of-bounds in scheduler. And
that if followed by slab corruption report in another task.

fs/jbd2/transaction.c happens to be the first meaningful file in this
crash, and so that's where it is attributed to.

Rerunning the reproducer several times can maybe give some better
glues, or maybe not, maybe they all will look equally puzzling.

This part of the repro looks familiar:

r1 =3D bpf$MAP_CREATE(0x0, &(0x7f0000002e40)=3D{0x12, 0x0, 0x4, 0x6e, 0x0,
0x1}, 0x68)
bpf$MAP_UPDATE_ELEM(0x2, &(0x7f0000000180)=3D{r1, &(0x7f0000000000),
&(0x7f0000000140)}, 0x20)

We had exactly such consequences of a bug in bpf map very recently,
but that was claimed to be fixed. Maybe not completely?
+bpf maintainers



> Most certainly the following code:
>
>   #ifdef CONFIG_SCHED_STACK_END_CHECK
>     if (task_stack_end_corrupted(prev))
>       panic("corrupted stack end detected inside scheduler\n");
>   #endif
>
> in schedule_debug() triggers the KASAN report.
> I guess we must disable CONFIG_SCHED_STACK_END_CHECK for KASAN builds.
>
>> However the stacktrace below shows a
>> problem in find_stack() function called by KASAN?
> For some reason the stackdepot hash table is corrupted. Looks like a
> separate issue.
>> And this does not seem to
>> be fs related at all? Also the reproducer has no sign of any filesystem
>> related activity...
>>
>>                                                                 Honza
>>
>> > CPU: 0 PID: 4718 Comm: syz-executor0 Not tainted 4.19.0-rc1+ #211
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S
>> > Google 01/01/2011
>> > Call Trace:
>> >
>> > The buggy address belongs to the page:
>> > page:ffffea0006b42400 count:1 mapcount:-512 mapping:0000000000000000
>> > index:0x0
>> > flags: 0x2fffc0000000000()
>> > raw: 02fffc0000000000 dead000000000100 dead000000000200 00000000000000=
00
>> > raw: 0000000000000000 0000000000000000 00000001fffffdff ffff8801d29544=
c0
>> > page dumped because: kasan: bad access detected
>> > page->mem_cgroup:ffff8801d29544c0
>> >
>> > Memory state around the buggy address:
>> >  ffff8801ad08ff00: f2 f2 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00 00 00
>> >  ffff8801ad08ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f1
>> > > ffff8801ad090000: f1 f1 f1 00 f2 f2 f2 f2 f2 f2 f2 04 f2 f2 f2 f2
>> >                    ^
>> >  ffff8801ad090080: f2 f2 f2 00 f2 f2 f2 00 00 00 00 00 00 00 00 00
>> >  ffff8801ad090100: 00 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> > Kernel panic - not syncing: panic_on_warn set ...
>> >
>> > BUG: unable to handle kernel paging request at 0000000100000007
>> > PGD 1b34a2067 P4D 1b34a2067 PUD 0
>> > Oops: 0000 [#1] SMP KASAN
>> > CPU: 1 PID: 4325 Comm: rs:main Q:Reg Tainted: G    B             4.19.=
0-rc1+
>> > #211
>> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S
>> > Google 01/01/2011
>> > RIP: 0010:find_stack lib/stackdepot.c:188 [inline]
>> > RIP: 0010:depot_save_stack+0x120/0x470 lib/stackdepot.c:238
>> > Code: 0f 00 4e 8b 24 f5 e0 db ae 89 4d 85 e4 0f 84 d4 00 00 00 44 8d 4=
7 ff
>> > 49 c1 e0 03 eb 0d 4d 8b 24 24 4d 85 e4 0f 84 bd 00 00 00 <41> 39 5c 24=
 08 75
>> > ec 41 3b 7c 24 0c 75 e5 48 8b 01 49 39 44 24 18
>> > RSP: 0018:ffff8801b2636f40 EFLAGS: 00010006
>> > RAX: 0000000084727a0d RBX: 00000000222ca320 RCX: ffff8801b2636fa0
>> > RDX: 000000004e510a9d RSI: 0000000000400000 RDI: 0000000000000012
>> > RBP: ffff8801b2636f78 R08: 0000000000000088 R09: 00000000dcf06c78
>> > R10: 00000000ecfd654a R11: ffff8801db1236f3 R12: 00000000ffffffff
>> > R13: ffff8801b2636f88 R14: 00000000000ca320 R15: ffff8801b2a72680
>> > FS:  00007ff2eb061700(0000) GS:ffff8801db100000(0000) knlGS:0000000000=
000000
>> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > CR2: 0000000100000007 CR3: 00000001b4fdd000 CR4: 00000000001406e0
>> > Call Trace:
>> >  save_stack+0xa9/0xd0 mm/kasan/kasan.c:454
>> >  set_track mm/kasan/kasan.c:460 [inline]
>> >  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
>> >  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
>> >  __cache_free mm/slab.c:3498 [inline]
>> >  kmem_cache_free+0x86/0x280 mm/slab.c:3756
>> >  jbd2_free_handle include/linux/jbd2.h:1426 [inline]
>> >  jbd2_journal_stop+0x443/0x1600 fs/jbd2/transaction.c:1787
>> >  __ext4_journal_stop+0xde/0x1f0 fs/ext4/ext4_jbd2.c:103
>> >  ext4_dirty_inode+0xab/0xc0 fs/ext4/inode.c:6027
>> >  __mark_inode_dirty+0x760/0x1300 fs/fs-writeback.c:2129
>> >  generic_update_time+0x26a/0x450 fs/inode.c:1651
>> >  update_time fs/inode.c:1667 [inline]
>> >  file_update_time+0x390/0x640 fs/inode.c:1877
>> >  __generic_file_write_iter+0x1dc/0x630 mm/filemap.c:3214
>> >  ext4_file_write_iter+0x390/0x1450 fs/ext4/file.c:266
>> >  call_write_iter include/linux/fs.h:1807 [inline]
>> >  new_sync_write fs/read_write.c:474 [inline]
>> >  __vfs_write+0x6af/0x9d0 fs/read_write.c:487
>> >  vfs_write+0x1fc/0x560 fs/read_write.c:549
>> >  ksys_write+0x101/0x260 fs/read_write.c:598
>> >  __do_sys_write fs/read_write.c:610 [inline]
>> >  __se_sys_write fs/read_write.c:607 [inline]
>> >  __x64_sys_write+0x73/0xb0 fs/read_write.c:607
>> >  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> > RIP: 0033:0x7ff2ecabf19d
>> > Code: d1 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c=
3 48
>> > 83 ec 08 e8 be fa ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b 3c 24=
 48 89
>> > c2 e8 07 fb ff ff 48 89 d0 48 83 c4 08 48 3d 01
>> > RSP: 002b:00007ff2eb05ff90 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
>> > RAX: ffffffffffffffda RBX: 0000000000000400 RCX: 00007ff2ecabf19d
>> > RDX: 0000000000000400 RSI: 0000000002089a90 RDI: 0000000000000005
>> > RBP: 0000000002089a90 R08: 00000000020d9e00 R09: 656c6c616b7a7973
>> > R10: 6c656e72656b2072 R11: 0000000000000293 R12: 0000000000000000
>> > R13: 00007ff2eb060410 R14: 00000000020d9e00 R15: 0000000002089890
>> > Modules linked in:
>> > Dumping ftrace buffer:
>> >    (ftrace buffer empty)
>> > CR2: 0000000100000007
>> > ---[ end trace fbf1ba842de6c894 ]---
>> > RIP: 0010:find_stack lib/stackdepot.c:188 [inline]
>> > RIP: 0010:depot_save_stack+0x120/0x470 lib/stackdepot.c:238
>> > Code: 0f 00 4e 8b 24 f5 e0 db ae 89 4d 85 e4 0f 84 d4 00 00 00 44 8d 4=
7 ff
>> > 49 c1 e0 03 eb 0d 4d 8b 24 24 4d 85 e4 0f 84 bd 00 00 00 <41> 39 5c 24=
 08 75
>> > ec 41 3b 7c 24 0c 75 e5 48 8b 01 49 39 44 24 18
>> > RSP: 0018:ffff8801b2636f40 EFLAGS: 00010006
>> > RAX: 0000000084727a0d RBX: 00000000222ca320 RCX: ffff8801b2636fa0
>> > RDX: 000000004e510a9d RSI: 0000000000400000 RDI: 0000000000000012
>> > RBP: ffff8801b2636f78 R08: 0000000000000088 R09: 00000000dcf06c78
>> > R10: 00000000ecfd654a R11: ffff8801db1236f3 R12: 00000000ffffffff
>> > R13: ffff8801b2636f88 R14: 00000000000ca320 R15: ffff8801b2a72680
>> > FS:  00007ff2eb061700(0000) GS:ffff8801db100000(0000) knlGS:0000000000=
000000
>> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > CR2: 0000000100000007 CR3: 00000001b4fdd000 CR4: 00000000001406e0
>> > Shutting down cpus with NMI
>> > Dumping ftrace buffer:
>> >    (ftrace buffer empty)
>> > Kernel Offset: disabled
>> > Rebooting in 86400 seconds..
>> >
>> >
>> > ---
>> > This bug is generated by a bot. It may contain errors.
>> > See https://goo.gl/tpsmEJ for more information about syzbot.
>> > syzbot engineers can be reached at syzkaller@googlegroups.com.
>> >
>> > syzbot will keep track of this bug report. See:
>> > https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
>> > syzbot.
>> > syzbot can test patches for this bug, for details see:
>> > https://goo.gl/tpsmEJ#testing-patches
>> >
>> --
>> Jan Kara <jack@suse.com>
>> SUSE Labs, CR
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msg=
id/syzkaller-bugs/20180829134620.GD7369%40quack2.suse.cz.
>> For more options, visit https://groups.google.com/d/optout.
>
>
>
> --
> Alexander Potapenko
> Software Engineer
>
> Google Germany GmbH
> Erika-Mann-Stra=C3=9Fe, 33
> 80636 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> Registergericht und -nummer: Hamburg, HRB 86891
> Sitz der Gesellschaft: Hamburg
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/CAG_fn%3DVMcHaGrFs_YvtBttmfuz8Rr1C_dfmKRibvPrbqeKFGCA%40ma=
il.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
