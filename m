From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sat, 23 Feb 2013 13:36:25 +0800
Message-ID: <51285559.201@gmail.com>
References: <87obfcs1x6.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:37321 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3BWFgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2013 00:36:31 -0500
Received: by mail-da0-f42.google.com with SMTP id z17so680915dal.1
        for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2013 21:36:31 -0800 (PST)
In-Reply-To: <87obfcs1x6.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

Thanks for pointing out.  I will fold your patch into this commit, and
take a close look at this bug right now.

Regards,
						- Zheng

On 02/23/2013 01:17 AM, Dmitry Monakhov wrote:
> 
> 301'th xfstests are failed due to :
> commit d100eef2440fea13e4f09e88b1c8bcbca64beb9f
> Author: Zheng Liu <wenqing.lz@taobao.com>
> Date:   Mon Feb 18 00:29:59 2013 -0500
> 
>     ext4: lookup block mapping in extent status tree
> 
> TESTCASE: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0
> 
>  ------------[ cut here ]------------
>  kernel BUG at fs/ext4/inode.c:1452!
>  invalid opcode: 0000 [#1] SMP 
>  Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes\
> l ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
>  CPU 2 
>  Pid: 2142, comm: fio Not tainted 3.8.0-rc3+ #41                  /DQ67SW
>  RIP: 0010:[<ffffffff81333c7b>]  [<ffffffff81333c7b>] mpage_da_submit_io+0x41b/0x5b0
>  RSP: 0018:ffff8801c2837a48  EFLAGS: 00010202
>  RAX: ffff880231e64bb0 RBX: ffff880231e64bb0 RCX: 0000000000000000
>  RDX: 0000000000000003 RSI: 0000000000000001 RDI: ffffffff821372d8
>  RBP: ffff8801c2837bb8 R08: ffff8801c2837df8 R09: 0000000000000001
>  R10: ffff880231e64bb1 R11: 0000000000000003 R12: ffffea00076f5c28
>  R13: 00000000000026d0 R14: ffff8801c2837be8 R15: 00000000000ea6d0
>  FS:  00007fefeaeb5700(0000) GS:ffff88023d800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fefdf10299c CR3: 0000000209154000 CR4: 00000000000407e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process fio (pid: 2142, threadinfo ffff8801c2836000, task ffff8801d3c48580)
>  Stack:
>   ffffffff82030f00 ffff8801c2837b58 ffff8801c2837df8 0000000000000000
>   ffff880231e64bb1 0000000000000001 ffff880231e64bb0 000000002ba68688
>   ffff8801c2837ae8 00000000000d4800 ffff880231f1cb98 00000000000026d0
>  Call Trace:
>   [<ffffffff81339769>] mpage_da_map_and_submit+0x369/0x3d0
>   [<ffffffff81339acb>] write_cache_pages_da+0x1db/0x6f0
>   [<ffffffff8133b07f>] ext4_da_writepages+0x49f/0x8b0
>   [<ffffffff81105d9a>] ? __lock_acquire+0x4ca/0x560
>   [<ffffffff811b4421>] do_writepages+0x51/0x70
>   [<ffffffff8119fc24>] __filemap_fdatawrite_range+0x64/0x70
>   [<ffffffff811a6a8b>] sys_fadvise64_64+0x25b/0x300
>   [<ffffffff811a6b3e>] sys_fadvise64+0xe/0x10
>   [<ffffffff818e9e99>] system_call_fastpath+0x16/0x1b
>  Code: a0 fe ff ff 4c 8b 95 b0 fe ff ff 49 63 d1 48 83 c2 02 48 8b 34 d5 30 4c 2b 82 48 83 c6 01 45 85 c9 48 89 34 d5 30 4c 2b 82 74 04 <0f> 0b eb fe 41 0f b6 56 13 83 e2 01 48 63 f2 48 83 c6 02 48 8b 
>  RIP  [<ffffffff81333c7b>] mpage_da_submit_io+0x41b/0x5b0
>   RSP <ffff8801c2837a48>
>  ---[ end trace 6f79fb4f46cf9f0e ]---
>  ------------[ cut here ]------------
> 
> Commit (d100eef2) this is very first commit where we try to make
> extent-status-tree usefull. Definitely this is because cached value
> is out of sync with real on-disk structure. I'll try to find out exact
> place where this happen, but i'm shure this is just a beginning.
> So Zheng please add sane self-testing infastructure for extent status
> tree,  for example like follows:
> 

