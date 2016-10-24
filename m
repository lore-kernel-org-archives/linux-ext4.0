From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [BUG] softlockup observed with 64k block size on ppc64
Date: Mon, 24 Oct 2016 14:10:02 +0530
Message-ID: <369354227.RU6GsvOxus@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tytso@mit.edu, jack@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46091 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934294AbcJXIkf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Oct 2016 04:40:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9O8caE6090145
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 04:40:35 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 268921mggk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 04:40:34 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Oct 2016 18:40:32 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
        by d23dlp01.au.ibm.com (Postfix) with ESMTP id 168062CE8057
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 19:40:29 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9O8eTfK2818354
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 19:40:29 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9O8eSkE009828
        for <linux-ext4@vger.kernel.org>; Mon, 24 Oct 2016 19:40:28 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The following soft lockup occurs when fstests' ext4/303 test is executed with
64k block size on a ppc64 machine running linux-4.8 kernel.

NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [fio:12268]
Modules linked in:
CPU: 1 PID: 12268 Comm: fio Not tainted 4.8.0 #1
task: c00000062d344900 task.stack: c0000006283c4000
NIP: c0000000003a55e4 LR: c0000000003a5564 CTR: 0000000000000000
REGS: c0000006283c6fb0 TRAP: 0901   Not tainted  (4.8.0)
MSR: 8000000002009032 <SF,VEC,EE,ME,IR,DR,RI>  CR: 44428848  XER: 00000000
CFAR: c0000000003a5670 SOFTE: 1
GPR00: c0000000003a79cc c0000006283c7230 c00000000110f100 0000000000008010
GPR04: 0000000000000000 c000000630fd7000 fffffffffffffffe 0000000000000010
GPR08: 0000000000008010 ffffffffffffffff 000000000000000f 0000000081860c2d
GPR12: 0000000024428244 c00000000fe00400
NIP [c0000000003a55e4] .ext4_mb_generate_buddy+0x1a4/0x450
LR [c0000000003a5564] .ext4_mb_generate_buddy+0x124/0x450
Call Trace:
[c0000006283c7230] [0000000000000002] 0x2 (unreliable)
[c0000006283c7340] [c0000000003a79cc] .ext4_mb_init_cache+0x43c/0x830
[c0000006283c7470] [c0000000003a8040] .ext4_mb_init_group+0x280/0x350
[c0000006283c7540] [c0000000003a8340] .ext4_mb_good_group+0x230/0x240
[c0000006283c75e0] [c0000000003abf8c] .ext4_mb_regular_allocator+0x2ec/0x540
[c0000006283c7720] [c0000000003ae1c0] .ext4_mb_new_blocks+0x680/0xd80
[c0000006283c7820] [c00000000039ee98] .ext4_ext_map_blocks+0x758/0x1d20
[c0000006283c79d0] [c000000000365e24] .ext4_map_blocks+0x1c4/0x750
[c0000006283c7ab0] [c000000000399230] .ext4_alloc_file_blocks.isra.6+0x170/0x3e0
[c0000006283c7be0] [c0000000003a1e24] .ext4_fallocate+0x2f4/0xa20
[c0000006283c7cf0] [c000000000283f54] .vfs_fallocate+0x144/0x290
[c0000006283c7d90] [c000000000285298] .SyS_fallocate+0x58/0xd0
[c0000006283c7e30] [c000000000009560] system_call+0x38/0x108
Instruction dump:
889e0014 7f042030 5484043e 7e892378 7d2907b4 7d4900d0 7d494838 7d070034
7d290074 2147001f 2129003f 7f895000 <409d0008> 7d495378 7d2a07b4 2e890000

-- 
chandan

