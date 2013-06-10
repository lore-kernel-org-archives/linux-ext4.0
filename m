From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: xfstests  shared/313 result in OOPS
Date: Mon, 10 Jun 2013 20:24:40 +0400
Message-ID: <87bo7evsqf.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53224 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FJQYo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jun 2013 12:24:44 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so5972891lab.28
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jun 2013 09:24:42 -0700 (PDT)
Received: from smtp.gmail.com (swsoft-msk-nat.sw.ru. [195.214.232.10])
        by mx.google.com with ESMTPSA id f9sm5950029lbf.4.2013.06.10.09.24.41
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Mon, 10 Jun 2013 09:24:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've run shared/313 (posted here http://patchwork.ozlabs.org/patch/244297)
And have got following bugon( BUG_ON(!PageLocked())

I think this also will be reproducible via shared/305
Currently I try to bisect this issue.

------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:1458!
invalid opcode: 0000 [#1] SMP 
Modules linked in: dm_flakey tun cpufreq_ondemand acpi_cpufreq
freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel
microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper
cryptd lrw gf128mul glue_helper aes_x86_64 ahci libahci pata_acpi
ata_generic dm_mirror dm_region_hash dm_log dm_mod
CPU: 2 PID: 12142 Comm: hwflush-check Tainted: G        W    3.10.0-rc2+
#78
Hardware name:                  /DQ67SW, BIOS
SWQ6710H.86A.0052.2011.0520.1802 05/20/2011
task: ffff8801c8a6cdc0 ti: ffff8802296f2000 task.ti: ffff8802296f2000
RIP: 0010:[<ffffffff81315cf7>]  [<ffffffff81315cf7>]
mpage_release_unused_pages+0x197/0x280
RSP: 0018:ffff8802296f3c08  EFLAGS: 00010202
RAX: 0000000000000003 RBX: ffffea0004332ad8 RCX: 00000000001d025f
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffffffff82136dc0
RBP: ffff8802296f3ce8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000003 R12: 0000000000000002
R13: ffff8802296f3c38 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f8c0dffb700(0000) GS:ffff88023d800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8bac003000 CR3: 000000022a1a6000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
 0000000000000000 ffff8802296f3c48 ffff8801a92d8aa0 0000000000000004
 00000000000005e6 ffff8802296f3c48 0000000000000004 0000000000000000
 ffffea0004332ad8 ffffea0004332b10 ffffea0004332b48 ffffea0006dd0000
Call Trace:
 [<ffffffff81193c47>] ? mempool_free_slab+0x17/0x20
 [<ffffffff81193d55>] ? mempool_free+0xe5/0x100
 [<ffffffff8127bca0>] ? bio_put+0xe0/0xf0
 [<ffffffff8131bcc4>] ext4_da_writepages+0x684/0x910
 [<ffffffff810f56be>] ? __lock_acquire+0x4fe/0x5c0
 [<ffffffff811a3071>] do_writepages+0x51/0x70
 [<ffffffff8118f464>] __filemap_fdatawrite_range+0x64/0x70
 [<ffffffff810f5e4a>] ? __lock_rele [<ffffffff81270288>]
 do_fsync+0x58/0xa0
 [<ffffffff81270300>] SyS_fsync+0x10/0x20
 [<ffffffff818d5c82>] system_call_fastpath+0x16/0x1b
Code: 83 f7 01 44 89 fe e8 f9 56 e5 ff 49 63 c7 48 83 c0 02 48 8b 14 c5
f0 f1 2a 82 48 83 c2 01 45 85 ff 48 89 14 c5 EXT4-fs (dm-1): mounted
filesystem with ordered data mode. Opts: acl,user_xattr
