From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: BUG: using smp_processor_id() in preemptible
Date: Wed, 20 Aug 2008 11:04:38 +0530
Message-ID: <20080820053438.GA6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:43063 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751727AbYHTFeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 01:34:46 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7K5YhqY013331
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:04:43 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7K5YhIR1515646
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:04:43 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7K5YgBc023769
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:04:42 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

BUG: using smp_processor_id() in preemptible [00000000] code:
fsstress/20995
caller is ext4_mb_initialize_context+0x20c/0x22c
Pid: 20995, comm: fsstress Not tainted 2.6.27-rc3-autokern1 #1
[<c0294a2f>] debug_smp_processor_id+0x9f/0xb8
[<c01e523d>] ext4_mb_initialize_context+0x20c/0x22c
[<c01ea017>] ext4_mb_new_blocks+0x17c/0x715
[<c0136b43>] ? trace_hardirqs_on+0xb/0xd
[<c01e23f2>] ext4_ext_get_blocks+0xbaf/0xde1
[<c0137d20>] ? __lock_acquire+0x61e/0x674
[<c0137d20>] ? __lock_acquire+0x61e/0x674
[<c01d464a>] ext4_get_blocks_wrap+0xce/0x1eb
[<c01dfaba>] ext4_fallocate+0x135/0x27d
[<c016472d>] ? fget+0x1d/0xd3
[<c01647aa>] ? fget+0x9a/0xd3
[<c01623a4>] sys_fallocate+0xce/0xf3
[<c0102bb9>] sysenter_do_call+0x12/0x35
=======================

