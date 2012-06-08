From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] ext4: fix hole punch failure when depth is greater
 than 0
Date: Thu, 7 Jun 2012 22:52:19 -0400
Message-ID: <20120608025219.GA28527@thunk.org>
References: <1338727489-16867-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1338727489-16867-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I tried applying this patch, and it causes fsstress to die in xfstests
#13.  I took a quick look, but the truncate/punch codepaths are one of
the more obscure parts of ext4, and it's not obvious what causing the
null dereference, which at first glance looks like is coming from
path->b_bh->b_data.

Also, please note that commit descriptions should be wrapped around
70-72 columns, so that "git log" is reasonable to look at on 80 column
terminals.

						- Ted

013	[   62.356981] BUG: unable to handle kernel NULL pointer dereference at 00000019
[   62.357880] IP: [<c029413f>] __ext4_ext_dirty+0x1c/0x52
[   62.358836] *pdpt = 00000000352d2001 *pde = 0000000000000000 
[   62.359528] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   62.360046] Modules linked in:
[   62.360046] 
[   62.360046] Pid: 7178, comm: fsstress Not tainted 3.5.0-rc1-00003-g69e292a-dirty #123 Bochs Bochs
[   62.360046] EIP: 0060:[<c029413f>] EFLAGS: 00010202 CPU: 0
[   62.360046] EIP is at __ext4_ext_dirty+0x1c/0x52
[   62.360046] EAX: 00000001 EBX: 000009c9 ECX: f603b948 EDX: 000009c9
[   62.360046] ESI: c07234c4 EDI: f6bc05a0 EBP: efd7ddd4 ESP: efd7ddc4
[   62.360046]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   62.360046] CR0: 8005003b CR2: 00000019 CR3: 352d1000 CR4: 000006f0
[   62.360046] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   62.360046] DR6: ffff0ff0 DR7: 00000400
[   62.360046] Process fsstress (pid: 7178, ti=efd7c000 task=f69214b0 task.ti=efd7c000)
[   62.360046] Stack:
[   62.360046]  f627f1ec 00000050 f627f1ec 00000007 efd7de8c c02962b9 f627f2e0 f6bc05a0
[   62.360046]  00000008 ffffffff ffffffff 80504000 f603b948 f62f1150 00000000 00000fe3
[   62.360046]  00010c15 00000000 f603b948 c071edb4 f5da6000 00000001 f627f1ec 00000012
[   62.360046] Call Trace:
[   62.360046]  [<c02962b9>] ext4_ext_remove_space+0x6c2/0xaeb
[   62.360046]  [<c0278998>] ? ext4_reserve_inode_write+0x38/0x6a
[   62.360046]  [<c0296bd3>] ext4_ext_truncate+0x127/0x199
[   62.360046]  [<c027a165>] ext4_truncate+0x7d/0xac
[   62.360046]  [<c027a483>] ext4_setattr+0x2ef/0x377
[   62.360046]  [<c0222636>] notify_change+0x1a6/0x27a
[   62.360046]  [<c020e69d>] do_truncate+0x69/0x82
[   62.360046]  [<c035094b>] ? security_inode_permission+0x1c/0x22
[   62.360046]  [<c020e8f7>] do_sys_truncate+0x12f/0x135
[   62.360046]  [<c020e913>] sys_truncate64+0x16/0x18
[   62.360046]  [<c06ec7c5>] syscall_call+0x7/0xb
[   62.360046]  [<c06e0000>] ? pci_acpi_scan_root+0x12a/0x258
[   62.360046] Code: 89 d1 ba 8b 00 00 00 e8 3b 4e 00 00 5a c9 c3 55 89 e5 57 56 53 83 ec 04 3e 8d 74 26 00 8b 7d 0c 89 c6 89 d3 8b 47 18 85 c0 74 24 <8b> 50 18 8b 45 08 89 4d f0 e8 6d ff ff ff 8b 4d f0 89 da 89 f0 
[   62.360046] EIP: [<c029413f>] __ext4_ext_dirty+0x1c/0x52 SS:ESP 0068:efd7ddc4
[   62.360046] CR2: 0000000000000019
[   62.395961] ---[ end trace d13d52b79a9cd4d5 ]---
