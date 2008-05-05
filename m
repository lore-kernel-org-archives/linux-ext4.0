From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Problem mounting ext2 using ext3?
Date: Mon, 5 May 2008 23:11:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805052304280.3160@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from monty.telenet-ops.be ([195.130.132.56]:54522 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761542AbYEEVLt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2008 17:11:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

	Hi,

When trying today's kernel (f74d505b58d36ceeef10e459094f0eb760681165) on
ARAnyM (emulated m68k Atari), I get

| Unable to handle kernel NULL pointer dereference at virtual address 000000b4
| Oops: 00000000
| Modules linked in:
| PC: [<000aad9e>] ext3_sync_fs+0x16/0x4a
| SR: 2304  SP: 00c09cc0  a2: 00c07a80
| d0: 00000001    d1: 00002300    d2: 00000002    d3: 00677600
| d4: 00677752    d5: 006776d2    a0: 00000000    a1: 00677600
| Process swapper (pid: 1, task=00c07a80)
| Frame format=7 eff addr=000000b4 ssw=0505 faddr=000000b4
| wb 1 stat/addr/data: 0000 00000000 00000000
| wb 2 stat/addr/data: 0000 00000000 00000000
| wb 3 stat/addr/data: 0000 000000b4 00000000
| push data: 00000000 00000000 00000000 00000000
| Stack from 00c09d28:
|         00c09d30 00677600 40000000 00c09df0 000909fe 00677600 00000001 00000001
|         00a02cd0 00000040 00000000 00000000 00000000 00677600 0022671c 00677600
|         00c09df0 00c09d7c 00677666 006776be 006776b2 00001000 00000000 00000000
|         00000000 00000001 00000000 00000000 00065b7a 00677600 ffffffff 00000000
|         00a02ce8 ffffffea 00065e5c 00677600 0067763a 0067b000 0067b000 0080de20
|         0022671c 00c09ea4 68646131 000e38de 00241072 00c01f70 000000d0 00241072
| Call Trace: [<000909fe>] vfs_quota_off+0xb4/0x562
|  [<00001000>] kernel_pg_dir+0x0/0x1000
|  [<00065b7a>] deactivate_super+0x44/0x72
|  [<00065e5c>] get_sb_bdev+0x12a/0x138
|  [<000e38de>] idr_pre_get+0x32/0x44
|  [<000e37f8>] ida_get_new+0x10/0x16
|  [<000a9930>] ext3_get_sb+0x1e/0x24

when mounting the root file system, which is ext2 (has_journal is not set).
Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.

At first I thought it was an issue with the byteswapped IDE bus on Atari (a
new and different solution to handle this just went into mainline), but if I
disable CONFIG_EXT3 support, it boots up fine.

Is this a known problem?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
