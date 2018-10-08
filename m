Return-Path: <SRS0=03HA=MU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:38750 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726391AbeJIDII (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2018 23:08:08 -0400
Received: from mr2.cc.vt.edu (inbound.smtp.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w98JshBQ016244
        for <linux-ext4@vger.kernel.org>; Mon, 8 Oct 2018 15:54:43 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w98Jscmm001239
        for <linux-ext4@vger.kernel.org>; Mon, 8 Oct 2018 15:54:43 -0400
Received: by mail-qk1-f197.google.com with SMTP id d200-v6so21967135qkc.22
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2018 12:54:43 -0700 (PDT)
From: valdis.kletnieks@vt.edu
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: [BUG] ext4 null pointer crash in linux-next
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1539028475_2640P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Oct 2018 15:54:35 -0400
Message-ID: <36243.1539028475@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1539028475_2640P
Content-Type: text/plain; charset=us-ascii

I'm seeing a fairly replicable crash/hang with a traceback implicating ext4 (or
possibly the block layer). next-20180918 seemed stable, but next-20180926 and
-next-20181005 have a habit of crashing while dnf is updating software (so far,
I've hit it 6 times with identical tracebacks while attempting to update software

This ringing any bells, or did I just buy myself another git bisect? Google says
that ext4_mpage_readpages from the traceback hasn't been referenced in the
last 2 months...

[  680.692888] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[  680.692895] PGD 0 P4D 0
[  680.692901] Oops: 0000 [#1] PREEMPT SMP PTI
[  680.692905] CPU: 3 PID: 15464 Comm: sh Tainted: G           O    T 4.19.0-rc6-next-20181005-dirty #621
[  680.692908] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A21 02/21/2018
[  680.692915] RIP: 0010:__get_request+0x31/0x7e0
[  680.692918] Code: 89 e5 41 57 41 56 41 55 49 89 fd 41 54 41 89 f4 53 48 83 ec 50 48 8b 1f 48 85 d2 48 89 55 b8 89 4d c0 44 89 45 c4 48 8b 43 18 <48> 8b 00 48 89 45 b0 0f 84 ba 03 00 00 48 8b 42 58 48 85 c0 48 89
[  680.692921] RSP: 0018:ffff9fa98d93f578 EFLAGS: 00010086
[  680.692925] RAX: 0000000000000000 RBX: ffff975ad40e7040 RCX: 0000000000000000
[  680.692927] RDX: ffff975aac306e00 RSI: 0000000000080000 RDI: ffff975acce39840
[  680.692930] RBP: ffff9fa98d93f5f0 R08: 0000000000600000 R09: 0000000000000001
[  680.692933] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000080000
[  680.692935] R13: ffff975acce39840 R14: ffff975aac306e00 R15: ffff975acce398c0
[  680.692938] FS:  00007f8fb7876740(0000) GS:ffff975adda00000(0000) knlGS:0000000000000000
[  680.692941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  680.692944] CR2: 0000000000000000 CR3: 00000003ebc64006 CR4: 00000000001606e0
[  680.692946] Call Trace:
[  680.692957]  get_request+0x214/0x8b0
[  680.692964]  ? remove_wait_queue+0x70/0x70
[  680.692971]  blk_queue_bio+0x23b/0x760
[  680.692977]  generic_make_request+0x2fe/0x570
[  680.692983]  submit_bio+0x4d/0x190
[  680.692987]  ? submit_bio+0x4d/0x190
[  680.692992]  ? bio_add_page+0x4b/0x60
[  680.692997]  ext4_mpage_readpages+0x814/0xed4
[  680.693002]  ? get_page_from_freelist+0x42c/0x1bd0
[  680.693015]  ext4_readpages+0x55/0x60
[  680.693020]  read_pages+0x72/0x190
[  680.693031]  __do_page_cache_readahead+0x1f6/0x220
[  680.693045]  ondemand_readahead+0x2ae/0x4f0
[  680.693055]  page_cache_sync_readahead+0x112/0x250
[  680.693065]  generic_file_buffered_read+0x542/0xf70
[  680.693079]  ? _raw_spin_unlock_irqrestore+0x78/0xa0
[  680.693087]  ? avc_update_node+0x1b6/0x2c0
[  680.693095]  generic_file_read_iter+0xd0/0x140
[  680.693102]  ext4_file_read_iter+0x6c/0x80
[  680.693107]  new_sync_read+0x121/0x1a0
[  680.693116]  __vfs_read+0x49/0x60
[  680.693120]  vfs_read+0x152/0x250
[  680.693126]  kernel_read+0x43/0x60
[  680.693131]  prepare_binprm+0x19b/0x1f0
[  680.693136]  __do_execve_file+0x5ca/0xbc0
[  680.693142]  __x64_sys_execve+0x38/0x50
[  680.693148]  do_syscall_64+0x8f/0xa52
[  680.693152]  ? trace_hardirqs_off_caller+0x22/0x150
[  680.693156]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  680.693162]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  680.693165] RIP: 0033:0x7f8fb7942b5b
[  680.693169] Code: 41 89 01 eb da 66 2e 0f 1f 84 00 00 00 00 00 f7 d8 64 41 89 01 eb d6 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 3b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fd 62 0f 00 f7 d8 64 89 01 48



--==_Exmh_1539028475_2640P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBW7u1+40DS38y7CIcAQK3lwgAo6YdaS1o78aU57SBUJpn/3Pp/4xdnJDB
jXozpDUwaCwAU6Py3Utb8e+dMkIxJGBRe3dpWx5zN8eABQfkeZu9o9S9zYzeG5lG
2xiwHC18sBZ7OHK/y0BdN7y3Vc6DA3bZ/U6lXsnt6wk4eeKM0U1niX2f51bMIYNL
ojYFTMFX++NVIQEY8QHZKJRwTU1GyP799rURWswOcjvhVsAJRUJahHJBm/5VYfBB
CncJQXGkcD60Juc12DzEk7kD6W3M0oAckQxeviQxsSImjBcyTV5I7klJY36/aqfR
LbXIQNFiVAT32tyJdWiT7i2sUT0VH7S6LpxdHjKCVUwKqnUdY9l9IQ==
=BZRg
-----END PGP SIGNATURE-----

--==_Exmh_1539028475_2640P--
