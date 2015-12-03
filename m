From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: v4.4-rc3 ext4 memory leak
Date: Thu, 3 Dec 2015 14:21:31 -0800
Message-ID: <5660C06B.4010003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:43968
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbbLCWgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Dec 2015 17:36:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Running xfstests on top of an ext4 filesystem causes kmemleak to report 
the following memory leak multiple times:

unreferenced object 0xffff880408709730 (size 96):
   comm "fsstress", pid 35588, jiffies 4295006079 (age 11865.680s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff8151056a>] kmemleak_alloc+0x7a/0xc0
     [<ffffffff81165e6e>] __kmalloc+0xde/0x140
     [<ffffffffa022472e>] ext4_find_extent+0x26e/0x310 [ext4]
     [<ffffffffa0227f15>] ext4_insert_range+0x255/0x3c0 [ext4]
     [<ffffffffa022aca1>] ext4_fallocate+0x1f1/0x210 [ext4]
     [<ffffffff81175fb6>] vfs_fallocate+0x156/0x1e0
     [<ffffffff8117608e>] SyS_fallocate+0x4e/0x80
     [<ffffffff8151b617>] entry_SYSCALL_64_fastpath+0x12/0x6f
     [<ffffffffffffffff>] 0xffffffffffffffff

Bart.
