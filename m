Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:35587 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJEWbm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2018 18:31:42 -0400
Received: by mail-io1-f68.google.com with SMTP id w11-v6so10980907iob.2
        for <linux-ext4@vger.kernel.org>; Fri, 05 Oct 2018 08:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181005130506.GA5972@hc>
References: <20181005101629.GA21469@hc> <CACT4Y+ZQr4DZtTLUxAe4HrC6=fQBQCJcs4U5xVjqsz8wu8uH8g@mail.gmail.com>
 <20181005130506.GA5972@hc>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 5 Oct 2018 17:32:07 +0200
Message-ID: <CACT4Y+bY=Ota1E_tf_QgsT9d2YdQ7xXE0k=Q1VPJga=Ge+1UpA@mail.gmail.com>
Subject: Re: KASAN: use-after-scope in ext4_group_desc_csum
To: Jan Glauber <Jan.Glauber@cavium.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 5, 2018 at 3:05 PM, Jan Glauber <Jan.Glauber@cavium.com> wrote:
> On Fri, Oct 05, 2018 at 01:13:52PM +0200, Dmitry Vyukov wrote:
>> On Fri, Oct 5, 2018 at 12:16 PM, Jan Glauber <Jan.Glauber@cavium.com> wrote:
>> > Hi,
>> >
>> > I'm getting below warning when I enable CONFIG_KASAN_EXTRA=y on a arm64 ThunderX2 system.
>> > As far as I can tell this is present since KASAN_EXTRA was introduced (4.16).
>> >
>> > [   64.547333] ==================================================================
>> > [   64.561933] BUG: KASAN: use-after-scope in ext4_es_lookup_extent+0x130/0x980
>> > [   64.576105] Write of size 4 at addr ffff80222d81f0ec by task exe/4075
>> >
>> > [   64.592044] CPU: 102 PID: 4075 Comm: exe Not tainted 4.19.0-rc6-jang+ #29
>> > [   64.605690] Hardware name: To be filled by O.E.M. Saber/To be filled by O.E.M., BIOS 0ACKL018 03/30/2018
>> > [   64.624750] Call trace:
>> > [   64.629666]  dump_backtrace+0x0/0x360
>> > [   64.637024]  show_stack+0x24/0x30
>> > [   64.643687]  dump_stack+0x12c/0x1b4
>> > [   64.650699]  print_address_description+0x68/0x2c8
>> > [   64.660152]  kasan_report+0x130/0x300
>> > [   64.667509]  __asan_store4+0x84/0xa8
>> > [   64.674693]  ext4_es_lookup_extent+0x130/0x980
>> > [   64.683623]  ext4_map_blocks+0xe0/0x990
>> > [   64.691330]  _ext4_get_block+0x130/0x2b8
>> > [   64.699211]  ext4_get_block+0x40/0x50
>> > [   64.706571]  generic_block_bmap+0x104/0x178
>> > [   64.714977]  ext4_bmap+0xc4/0x198
>> > [   64.721636]  bmap+0x54/0x70
>> > [   64.727250]  jbd2_journal_init_inode+0x2c/0x208
>> > [   64.736355]  ext4_fill_super+0x5080/0x5c90
>> > [   64.744587]  mount_bdev+0x1e0/0x228
>> > [   64.751597]  ext4_mount+0x44/0x58
>> > [   64.758255]  mount_fs+0x58/0x1b8
>> > [   64.764740]  vfs_kern_mount.part.2+0xc0/0x2a8
>> > [   64.773495]  do_mount+0x7a8/0x13e8
>> > [   64.780327]  ksys_mount+0x9c/0x110
>> > [   64.787160]  __arm64_sys_mount+0x70/0x88
>> > [   64.795043]  el0_svc_handler+0xac/0x150
>> > [   64.802749]  el0_svc+0x8/0xc
>> >
>> > [   64.811521] The buggy address belongs to the page:
>> > [   64.821149] page:ffff7e0088b607c0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
>> > [   64.837249] flags: 0x1ffff00000000000()
>> > [   64.844959] raw: 1ffff00000000000 ffff7e0088b607c8 ffff7e0088b607c8 0000000000000000
>> > [   64.860527] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>> > [   64.876093] page dumped because: kasan: bad access detected
>> >
>> > [   64.890278] Memory state around the buggy address:
>> > [   64.899907]  ffff80222d81ef80: f2 f2 f2 f2 00 f2 f2 f2 f2 f2 f2 f2 00 f2 f2 f2
>> > [   64.914426]  ffff80222d81f000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> > [   64.928945] >ffff80222d81f080: f8 f8 f8 f8 f8 f8 f1 f1 f1 f1 f8 f8 f8 f8 00 f2
>> > [   64.943463]                                                           ^
>> > [   64.956759]  ffff80222d81f100: f2 f2 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>> > [   64.971278]  ffff80222d81f180: f8 f8 f8 f8 f1 f1 f1 f1 00 00 00 f2 f8 f8 f8 f8
>> > [   64.985795] ==================================================================
>> > [   65.000312] Disabling lock debugging due to kernel taint
>> > [   65.037509] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
>> >
>> > I'm not seeing any issues like filesystem corruption or misbehaviour that could be related
>> > the warning.
>> >
>> > Is this a false positive? Any thoughts?
>>
>>
>> Hi Jan,
>>
>> What kernel commit are you using? Kernel config? Compiler?
>> Please symbolize the report with scripts/decode_stacktrace.sh in
>> kernel tree or https://github.com/google/sanitizers/blob/master/address-sanitizer/tools/kasan_symbolize.py
>
> Hi Dmitry,
>
> I can reproduce this since 4.16, the report above is from 4.19-rc6.
> Kernel config:
> https://paste.debian.net/1046031/
>
> Compiler is the stock gcc from Ubuntu 18.04.1:
> gcc version 7.3.0 (Ubuntu/Linaro 7.3.0-27ubuntu1~18.04)
>
> Here is the decoded stacktrace:
> [   64.547333] ==================================================================
> [   64.561933] BUG: KASAN: use-after-scope in ext4_es_lookup_extent (fs/ext4/extents_status.c:795)
> [   64.576105] Write of size 4 at addr ffff80222d81f0ec by task exe/4075
>
> [   64.592044] CPU: 102 PID: 4075 Comm: exe Not tainted 4.19.0-rc6-jang+ #29
> [   64.605690] Hardware name: To be filled by O.E.M. Saber/To be filled by O.E.M., BIOS 0ACKL018 03/30/2018
> [   64.624750] Call trace:
> [   64.629666] dump_backtrace (arch/arm64/kernel/traps.c:102)
> [   64.637024] show_stack (arch/arm64/kernel/traps.c:154)
> [   64.643687] dump_stack (lib/dump_stack.c:115)
> [   64.650699] print_address_description (mm/kasan/report.c:257)
> [   64.660152] kasan_report (mm/kasan/report.c:355 mm/kasan/report.c:412)
> [   64.667509] __asan_store4 (mm/kasan/kasan.c:699)
> [   64.674693] ext4_es_lookup_extent (fs/ext4/extents_status.c:795)
> [   64.683623] ext4_map_blocks (fs/ext4/inode.c:526)
> [   64.691330] _ext4_get_block (fs/ext4/inode.c:783 (discriminator 3))
> [   64.699211] ext4_get_block (fs/ext4/inode.c:802)
> [   64.706571] generic_block_bmap (fs/buffer.c:2969)
> [   64.714977] ext4_bmap (fs/ext4/inode.c:3314)
> [   64.721636] bmap (fs/inode.c:1595)
> [   64.727250] jbd2_journal_init_inode (fs/jbd2/journal.c:1257)
> [   64.736355] ext4_fill_super (fs/ext4/super.c:4615 fs/ext4/super.c:4770 fs/ext4/super.c:4157)
> [   64.744587] mount_bdev (fs/super.c:1158)
> [   64.751597] ext4_mount (fs/ext4/super.c:5869)
> [   64.758255] mount_fs (fs/super.c:1261)
> [   64.764740] vfs_kern_mount.part.2 (fs/namespace.c:961)
> [   64.773495] do_mount (fs/namespace.c:2454 fs/namespace.c:2457 fs/namespace.c:2787)
> [   64.780327] ksys_mount (fs/namespace.c:3003)
> [   64.787160] __arm64_sys_mount (fs/namespace.c:3014)
> [   64.795043] el0_svc_handler (arch/arm64/kernel/syscall.c:36 arch/arm64/kernel/syscall.c:48 arch/arm64/kernel/syscall.c:84 arch/arm64/kernel/syscall.c:130)
> [   64.802749] el0_svc (arch/arm64/kernel/entry.S:918)
>
> [   64.811521] The buggy address belongs to the page:
> [   64.821149] page:ffff7e0088b607c0 count:0 mapcount:0 mapping:0000000000000000 index:0x0
> [   64.837249] flags: 0x1ffff00000000000()
> [   64.844959] raw: 1ffff00000000000 ffff7e0088b607c8 ffff7e0088b607c8 0000000000000000
> [   64.860527] raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> [   64.876093] page dumped because: kasan: bad access detected
>
> [   64.890278] Memory state around the buggy address:
> [   64.899907]  ffff80222d81ef80: f2 f2 f2 f2 00 f2 f2 f2 f2 f2 f2 f2 00 f2 f2 f2
> [   64.914426]  ffff80222d81f000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> [   64.928945] >ffff80222d81f080: f8 f8 f8 f8 f8 f8 f1 f1 f1 f1 f8 f8 f8 f8 00 f2
> [   64.943463]                                                           ^
> [   64.956759]  ffff80222d81f100: f2 f2 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
> [   64.971278]  ffff80222d81f180: f8 f8 f8 f8 f1 f1 f1 f1 00 00 00 f2 f8 f8 f8 f8
> [   64.985795] ==================================================================
> [   65.000312] Disabling lock debugging due to kernel taint
> [   65.037509] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)


Thanks for the detailed info.

I've looked at the code and I don't see how es variable can be subject
to use-after-scope at that point. What happens with es is pretty
straightforward, no loop, no pointer memorization for future use, etc.
So this looks like a false positive.

There was a know use-after-scope false positive related to STRUCTLEAK
config, but it is not enabled here.

I've looked at disasm of ext4_map_blocks and ext4_es_lookup_extent and
do not see anything suspicious. I don't see use-after-scope (0xf8)
poisoning happening before that point at all.

"Memory state around the buggy address" looks somewhat suspicious. es
variable is 5 words, and there is indeed 5 words between left and
right (0xf1, 0xf2) redzones. However, only 4 words of the variable are
poisoned as after-scope (0xf8). This generally should not happen:
either the whole object is after-scope, or none of the object is
after-scope.

This all makes me think that somebody else has left these 0xf8 in
shadow before ext4_map_blocks started executing.
Unfortunately debugging garbage in stack shadow is not completely
trivial and there is no common recipe. I don't have setup to run arm64
kernel at the moment. I would try to locate that garbage in stack
shadow earlier, e.g. calling another function before ext4_map_blocks,
implementing that function in mm/kasan/kasan.c (non-instrumented
itself) and then try to scan stack and verify presence of 0xf8
garbage. If this works out, then try to catch garbage earlier and/or
try to figure out what function left that garbage (that's possible by
locating 0x41b58ab3 magic:
https://bugzilla.kernel.org/show_bug.cgi?id=198435).
