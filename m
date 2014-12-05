From: Chris Mason <clm@fb.com>
Subject: Crash in ext4_fill_super in linux-next
Date: Fri, 5 Dec 2014 15:41:33 -0500
Message-ID: <1417812093.4845.3@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "'linux-ext4'" <linux-ext4@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63422 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbaLEUls (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Dec 2014 15:41:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

I can't mount ext4 in linux-next:

[   10.308422] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000012
[   10.324470] IP: [<ffffffff81265e86>] ext4_fill_super+0x2336/0x3180
[   10.337045] PGD 0
[   10.341296] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   10.350786] Modules linked in: megaraid_sas
[   10.359479] CPU: 8 PID: 2917 Comm: mount Not tainted 
3.18.0-rc7-next-20141205-mason+ #17
[   10.375846] Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, 
BIOS 1.07 05/10/2012
[   10.391691] task: ffff880848d4c3d0 ti: ffff880848a7c000 task.ti: 
ffff880848a7c000
[   10.406841] RIP: 0010:[<ffffffff81265e86>]  [<ffffffff81265e86>] 
ext4_fill_super+0x2336/0x3180
[   10.424340] RSP: 0018:ffff880848a7fc68  EFLAGS: 00010246
[   10.435075] RAX: ffff88104b1a7000 RBX: ffff881054d86800 RCX: 
0000000000000000
[   10.449472] RDX: 000000000452beff RSI: 00000000000001d1 RDI: 
0000000000083f99
[   10.463862] RBP: ffff880848a7fd58 R08: 0000000000000000 R09: 
0000000000000002
[   10.478252] R10: 0000000000000000 R11: 0000000000000001 R12: 
ffff88104b1a7000
[   10.492640] R13: 00000000000008a6 R14: 0000000000000080 R15: 
ffff881046905400
[   10.507031] FS:  00007f3d24e2f7e0(0000) GS:ffff881075e00000(0000) 
knlGS:0000000000000000
[   10.523400] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.535012] CR2: 0000000000000012 CR3: 0000001040a75000 CR4: 
00000000000407e0
[   10.549405] Stack:
[   10.553566]  0000000000000020 ffff880848a7fd88 ffff881046906fe0 
ffff88104573bf80
[   10.568938]  0000001254d86800 ffff880848a7fd88 ffff88084a53f801 
00000000000008a6
[   10.584315]  0000000000000012 ffff88104b1a7000 0000000000000000 
0000000000000000
[   10.599693] Call Trace:
[   10.604726]  [<ffffffff8109fb5d>] ? 
trace_hardirqs_on_caller+0x10d/0x1d0
[   10.618242]  [<ffffffff811b3ac2>] mount_bdev+0x1a2/0x1e0
[   10.628991]  [<ffffffff8116e783>] ? pcpu_alloc+0x353/0x660
[   10.640088]  [<ffffffff81263b50>] ? 
ext4_alloc_flex_bg_array+0x120/0x120
[   10.653624]  [<ffffffff81255a75>] ext4_mount+0x15/0x20
[   10.664018]  [<ffffffff811b3633>] mount_fs+0x43/0x1b0
[   10.674234]  [<ffffffff8116eac5>] ? __alloc_percpu+0x15/0x20
[   10.685666]  [<ffffffff811d35b6>] vfs_kern_mount+0x76/0x160
[   10.696939]  [<ffffffff811d42a7>] do_mount+0x237/0xab0
[   10.707344]  [<ffffffff811774f6>] ? might_fault+0x66/0xc0
[   10.718254]  [<ffffffff811d4b9b>] SyS_mount+0x7b/0xc0
[   10.728471]  [<ffffffff816629d2>] system_call_fastpath+0x12/0x17
[   10.740612] Code: 60 ff ff ff 4c 8b a5 58 ff ff ff 44 89 f1 48 c7 c2 
20 6a a2 81 48 c7 c6 de 95 9f 81 48 89 df 31 c0 e8 4f 24 ff ff e9 50 f1 
ff ff <f6> 41 12 04 45 0f 44 ee e9 60 ef ff ff 44 8b ad 60 ff ff ff 4c

(gdb) list *ext4_fill_super+0x2336
0xffffffff81265e86 is in ext4_fill_super (fs/ext4/super.c:2082).
2077				last_block = ext4_blocks_count(sbi->s_es) - 1;
2078			else
2079				last_block = first_block +
2080					(EXT4_BLOCKS_PER_GROUP(sb) - 1);
2081
2082			if ((grp == sbi->s_groups_count) &&
2083			   !(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
                           ^^^^^^^^^^^^^^^^^^^^^^^^
2084				grp = i;
2085
2086			block_bitmap = ext4_block_bitmap(sb, gdp);

Looks like gdp is NULL.

I reverted this one:

commit fdfe073987619ec375da8d8a2701ab271d1b1339
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Tue Dec 2 16:09:16 2014 -0500

    ext4: fix potential use after free during resize

And I can mount again.  A quick look at the archives show that Sergey 
hit the same thing, so I've cc'd him.

-chris

