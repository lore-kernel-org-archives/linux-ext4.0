From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] softlockup observed with 64k block size on ppc64
Date: Tue, 25 Oct 2016 10:13:19 +0200
Message-ID: <20161025081319.GC16260@quack2.suse.cz>
References: <369354227.RU6GsvOxus@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59733 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753302AbcJYINV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Oct 2016 04:13:21 -0400
Content-Disposition: inline
In-Reply-To: <369354227.RU6GsvOxus@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Mon 24-10-16 14:10:02, Chandan Rajendra wrote:
> The following soft lockup occurs when fstests' ext4/303 test is executed with
> 64k block size on a ppc64 machine running linux-4.8 kernel.

Thanks for report! I had a look into the code and I'm not sure why this
happens. Is this reproducible? Did it happen also with older kernels?

								Honza
> 
> NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [fio:12268]
> Modules linked in:
> CPU: 1 PID: 12268 Comm: fio Not tainted 4.8.0 #1
> task: c00000062d344900 task.stack: c0000006283c4000
> NIP: c0000000003a55e4 LR: c0000000003a5564 CTR: 0000000000000000
> REGS: c0000006283c6fb0 TRAP: 0901   Not tainted  (4.8.0)
> MSR: 8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 44428848  XER: 00000000
> CFAR: c0000000003a5670 SOFTE: 1
> GPR00: c0000000003a79cc c0000006283c7230 c00000000110f100 0000000000008010
> GPR04: 0000000000000000 c000000630fd7000 fffffffffffffffe 0000000000000010
> GPR08: 0000000000008010 ffffffffffffffff 000000000000000f 0000000081860c2d
> GPR12: 0000000024428244 c00000000fe00400
> NIP [c0000000003a55e4] .ext4_mb_generate_buddy+0x1a4/0x450
> LR [c0000000003a5564] .ext4_mb_generate_buddy+0x124/0x450
> Call Trace:
> [c0000006283c7230] [0000000000000002] 0x2 (unreliable)
> [c0000006283c7340] [c0000000003a79cc] .ext4_mb_init_cache+0x43c/0x830
> [c0000006283c7470] [c0000000003a8040] .ext4_mb_init_group+0x280/0x350
> [c0000006283c7540] [c0000000003a8340] .ext4_mb_good_group+0x230/0x240
> [c0000006283c75e0] [c0000000003abf8c] .ext4_mb_regular_allocator+0x2ec/0x540
> [c0000006283c7720] [c0000000003ae1c0] .ext4_mb_new_blocks+0x680/0xd80
> [c0000006283c7820] [c00000000039ee98] .ext4_ext_map_blocks+0x758/0x1d20
> [c0000006283c79d0] [c000000000365e24] .ext4_map_blocks+0x1c4/0x750
> [c0000006283c7ab0] [c000000000399230] .ext4_alloc_file_blocks.isra.6+0x170/0x3e0
> [c0000006283c7be0] [c0000000003a1e24] .ext4_fallocate+0x2f4/0xa20
> [c0000006283c7cf0] [c000000000283f54] .vfs_fallocate+0x144/0x290
> [c0000006283c7d90] [c000000000285298] .SyS_fallocate+0x58/0xd0
> [c0000006283c7e30] [c000000000009560] system_call+0x38/0x108
> Instruction dump:
> 889e0014 7f042030 5484043e 7e892378 7d2907b4 7d4900d0 7d494838 7d070034
> 7d290074 2147001f 2129003f 7f895000 <409d0008> 7d495378 7d2a07b4 2e890000
> 
> -- 
> chandan
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
