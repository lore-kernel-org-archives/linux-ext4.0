From: Thomas Deutschmann <whissi@whissi.de>
Subject: linux-4.4.18 crashed in find_inode_fast while deleting directory
Date: Sat, 20 Aug 2016 16:50:34 +0200
Message-ID: <768259a7-ed21-6538-8f82-76a19359e03e@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yamato.tf-network.de ([93.186.202.221]:59902 "EHLO
        yamato.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbcHTPBH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Aug 2016 11:01:07 -0400
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 3sGjSD50QSz4DYt
        for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2016 16:50:36 +0200 (CEST)
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id gBbB9NudbMyl for <linux-ext4@vger.kernel.org>;
        Sat, 20 Aug 2016 16:50:35 +0200 (CEST)
Received: from [192.168.2.10] (p578671EC.dip0.t-ipconnect.de [87.134.113.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 3sGjSC2jyDz4DYs
        for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2016 16:50:35 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

while deleting a directory containing gcc-5.4.0 sources linux-4.4.18
crashed with:

> [...]
> [198.425403] RHX: 0000000000000000 RBX: 00000000ffffff28 RCX: 0000000000000012
> [198.425776] RDX: 0000000000006016 RSI: ffff8800b9a46060 RDI: ffff8800b8b0e800
> [198.426145] RBP: ffff8800b36d3d68 Ro8: 0000000000006016 Ro9: ffff8800b6419958
> [198.426524] R10: ffff8800b5f36400 R11: 0000000000000028 R12: 0000000000006016
> [198.426904] R13: ffff8800b8b0e800 R14: ffff8800b9a46060 R15: 0000000000000002
> [198.427284] FS:  00007f7a23216700(0000) GS:ffff8800ba020000(0000) knlGS:0000000000000000
> [198.427667] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [198.428095] CR2: 00000000ffffff60 CR3: 00000000b5e07000 CR4: 00000000001406e0
> [198.428517] Stack:
> [198.428916] 0000000000006016 ffff8800b8b0e800 0000000000006016 ffff8800b9a46060
> [198.429338] 0000000000000002 ffff8800b36d3da0 ffffffff81215709 ffff8800b6175fc8
> [198.429735] ffff8800b61ac180 0000000000006016 ffff8800b8b0e800 0000000000000002
> [198.430163] Call Trace:
> [198.430576] [<ffffffff81215709>] iget_locked+ox69/0x170
> [198.431015] [<ffffffff8127c6ed>] ext4_iget+0x3d/0xb20
> [198.431440] [<ffffffff81212d0a>] ? __d_alloc+0x13a/0x170
> [198.431870] [<ffffffff8127d1fb>] ext4_iget_normal+0x2b/0x30
> [198.432287] [<ffffffff81286ed6>] ext4_lookup+0x96/0x140
> [198.432699] [<ffffffff81204d58>] lookup_real+0x18/0x60
> [198.433093] [<ffffffff812062ee>] __lookup_hash+0x2e/0x40
> [198.433484] [<ffffffff8120a891>] do_unlinkat+0x121/0x290
> [198.433865] [<ffffffff8120b306>] SyS_unlinkat+0x16/0x30
> [198.434236] [<ffffffff8166df57>] entry_SYSCALL_64_fastpath+0x12/0x66
> [198.434612] Code: 49 89 fd 41 54 49 89 d4 53 49 8b 1e 48 85 db 75 0e eb 4c 48 8b 9b d8 00 00 00 48 85 db 74 40 48 81 eb d8 00 00 00 48 85 db 74 34 <4c> 39 63 38 75 e2 40 39 6b 28 75 dc 4c 8d bb 80 00 00 00 4c 89
> [198.435786] RIP [<ffffffff81214678>] find_inode_fast+0x38/0x90
> [198.436150]  RSP <ffff880ob36d3d40>
> [198.436513] CR2: 00000000ffffff60
> [198.436861] ---[ end trace dfe3106be8oeb2d7 ]---
> [198.437181] note: rm[5815] exited with preempt_count 1

Text was extracted from a screenshot using OCR. Original screenshot:
http://666kb.com/i/dboxb0sei3pe9we0w.png

Please CC on reply because I am not subscribed to the ext4 mailing list.


-- 
Regards,
Thomas
