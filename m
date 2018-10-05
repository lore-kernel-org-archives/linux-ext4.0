Return-Path: <SRS0=0MVU=MR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:53045 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbeJESMc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2018 14:12:32 -0400
Received: by mail-it1-f196.google.com with SMTP id 134-v6so2083891itz.2
        for <linux-ext4@vger.kernel.org>; Fri, 05 Oct 2018 04:14:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181005101629.GA21469@hc>
References: <20181005101629.GA21469@hc>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 5 Oct 2018 13:13:52 +0200
Message-ID: <CACT4Y+ZQr4DZtTLUxAe4HrC6=fQBQCJcs4U5xVjqsz8wu8uH8g@mail.gmail.com>
Subject: Re: KASAN: use-after-scope in ext4_group_desc_csum
To: Jan Glauber <Jan.Glauber@cavium.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 5, 2018 at 12:16 PM, Jan Glauber <Jan.Glauber@cavium.com> wrote:
> Hi,
>
> I'm getting below warning when I enable CONFIG_KASAN_EXTRA=y on a arm64 ThunderX2 system.
> As far as I can tell this is present since KASAN_EXTRA was introduced (4.16).
>
> [   64.547333] ==================================================================
> [   64.561933] BUG: KASAN: use-after-scope in ext4_es_lookup_extent+0x130/0x980
> [   64.576105] Write of size 4 at addr ffff80222d81f0ec by task exe/4075
>
> [   64.592044] CPU: 102 PID: 4075 Comm: exe Not tainted 4.19.0-rc6-jang+ #29
> [   64.605690] Hardware name: To be filled by O.E.M. Saber/To be filled by O.E.M., BIOS 0ACKL018 03/30/2018
> [   64.624750] Call trace:
> [   64.629666]  dump_backtrace+0x0/0x360
> [   64.637024]  show_stack+0x24/0x30
> [   64.643687]  dump_stack+0x12c/0x1b4
> [   64.650699]  print_address_description+0x68/0x2c8
> [   64.660152]  kasan_report+0x130/0x300
> [   64.667509]  __asan_store4+0x84/0xa8
> [   64.674693]  ext4_es_lookup_extent+0x130/0x980
> [   64.683623]  ext4_map_blocks+0xe0/0x990
> [   64.691330]  _ext4_get_block+0x130/0x2b8
> [   64.699211]  ext4_get_block+0x40/0x50
> [   64.706571]  generic_block_bmap+0x104/0x178
> [   64.714977]  ext4_bmap+0xc4/0x198
> [   64.721636]  bmap+0x54/0x70
> [   64.727250]  jbd2_journal_init_inode+0x2c/0x208
> [   64.736355]  ext4_fill_super+0x5080/0x5c90
> [   64.744587]  mount_bdev+0x1e0/0x228
> [   64.751597]  ext4_mount+0x44/0x58
> [   64.758255]  mount_fs+0x58/0x1b8
> [   64.764740]  vfs_kern_mount.part.2+0xc0/0x2a8
> [   64.773495]  do_mount+0x7a8/0x13e8
> [   64.780327]  ksys_mount+0x9c/0x110
> [   64.787160]  __arm64_sys_mount+0x70/0x88
> [   64.795043]  el0_svc_handler+0xac/0x150
> [   64.802749]  el0_svc+0x8/0xc
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
>
> I'm not seeing any issues like filesystem corruption or misbehaviour that could be related
> the warning.
>
> Is this a false positive? Any thoughts?


Hi Jan,

What kernel commit are you using? Kernel config? Compiler?
Please symbolize the report with scripts/decode_stacktrace.sh in
kernel tree or https://github.com/google/sanitizers/blob/master/address-sanitizer/tools/kasan_symbolize.py
