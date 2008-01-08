From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mballoc and inode prealloc space deletion
Date: Tue, 8 Jan 2008 16:23:41 +0530
Message-ID: <20080108105341.GA11659@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:33153 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751144AbYAHKx6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jan 2008 05:53:58 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m08Arglo003541
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 16:23:42 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m08ArgBj708762
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 16:23:42 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m08ArgrI025512
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 10:53:42 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Alex,

With the latest changes i see both group preallocation and inode
preallocation being used by mballoc. Since the choice is now made with
file size not just the request size. (None of the test were actually
using inode prealloc previously). Now that the test are using inode prealloc i
see the below dump stack on the console. I guess you put in the dump
stack there to  find out how often these happen. Do you still want the
dump stack to be there. Or can I remove it. ?

uh-oh! some one just deleted it
Call Trace:
[c0000000e4143970] [c000000000010554] .show_stack+0x6c/0x1a0
(unreliable)
[c0000000e4143a10] [c00000000019db90]
.ext4_mb_discard_inode_preallocations+0x1d4/0x428
[c0000000e4143b20] [c000000000178e8c]
.ext4_discard_reservation+0x30/0xb4
[c0000000e4143bc0] [c00000000017c0b8] .ext4_release_file+0x54/0xbc
[c0000000e4143c50] [c0000000000de4b0] .__fput+0x114/0x214
[c0000000e4143d00] [c0000000000db2d8] .filp_close+0xb0/0xd8
[c0000000e4143d90] [c0000000000dbb20] .sys_close+0xc4/0x128
[c0000000e4143e30] [c00000000000872c] syscall_exit+0x0/0x40
uh-oh! some one just deleted it
Call Trace:
[c0000000ede97970] [c000000000010554] .show_stack+0x6c/0x1a0
(unreliable)
[c0000000ede97a10] [c00000000019db90]
.ext4_mb_discard_inode_preallocations+0x1d4/0x428
[c0000000ede97b20] [c000000000178e8c]
.ext4_discard_reservation+0x30/0xb4
[c0000000ede97bc0] [c00000000017c0b8] .ext4_release_file+0x54/0xbc
[c0000000ede97c50] [c0000000000de4b0] .__fput+0x114/0x214
[c0000000ede97d00] [c0000000000db2d8] .filp_close+0xb0/0xd8
[c0000000ede97d90] [c0000000000dbb20] .sys_close+0xc4/0x128
[c0000000ede97e30] [c00000000000872c] syscall_exit+0x0/0x40
uh-oh! some one just deleted it
Call Trace:
[c0000000e6b1f970] [c000000000010554] .show_stack+0x6c/0x1a0
(unreliable)
[c0000000e6b1fa10] [c00000000019db90]
.ext4_mb_discard_inode_preallocations+0x1d4/0x428
[c0000000e6b1fb20] [c000000000178e8c]
.ext4_discard_reservation+0x30/0xb4
[c0000000e6b1fbc0] [c00000000017c0b8] .ext4_release_file+0x54/0xbc
[c0000000e6b1fc50] [c0000000000de4b0] .__fput+0x114/0x214
[c0000000e6b1fd00] [c0000000000db2d8] .filp_close+0xb0/0xd8
[c0000000e6b1fd90] [c0000000000dbb20] .sys_close+0xc4/0x128
[c0000000e6b1fe30] [c00000000000872c] syscall_exit+0x0/0x40
-- 0:conmux-control -- time-stamp -- Jan/08/08  2:20:11 --
-- 0:conmux-control -- time-stamp -- Jan/08/08  2:38:19 --
(bot:conmon-payload) disconnected
