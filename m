From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: FIEMAP related circular locking dependency detected
Date: Mon, 4 May 2009 14:51:30 +0530
Message-ID: <20090504092130.GA14214@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57611 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZEDJVj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 May 2009 05:21:39 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id n449L1Sh002167
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:21:01 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n449LdlV454914
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:21:39 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n449LdlX013471
	for <linux-ext4@vger.kernel.org>; Mon, 4 May 2009 19:21:39 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.30-rc4-autokern1 #1
-------------------------------------------------------
a.out/5595 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c047f023>] might_fault+0x35/0x72

but task is already holding lock:
 (&ei->i_data_sem){++++..}, at: [<c04f2f71>] ext4_fiemap+0x139/0x191

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ei->i_data_sem){++++..}:
       [<c044817e>] validate_chain+0x89b/0xba1
       [<c0448b28>] __lock_acquire+0x6a4/0x73c
       [<c0449d40>] lock_acquire+0xa8/0xc8
       [<c06a6f91>] down_read+0x1e/0x5b
       [<c04e1a83>] ext4_get_blocks_wrap+0x28/0x27e
       [<c04e2782>] ext4_get_block+0x94/0xc9
       [<c04b3171>] do_mpage_readpage+0x24b/0x5e0
       [<c04b3620>] mpage_readpages+0x74/0xa8
       [<c04e0edc>] ext4_readpages+0x14/0x16
       [<c04732bd>] __do_page_cache_readahead+0x14f/0x1b8
       [<c04736bf>] do_page_cache_readahead+0x42/0x53
       [<c046e57b>] filemap_fault+0x194/0x3ad
       [<c047bea2>] __do_fault+0x3b/0x35c
       [<c047db7b>] handle_mm_fault+0x36d/0x7a9
       [<c06aa208>] do_page_fault+0x28d/0x2f1
       [<c06a8612>] error_code+0x72/0x78
       [<ffffffff>] 0xffffffff

-> #0 (&mm->mmap_sem){++++++}:
       [<c0447eb2>] validate_chain+0x5cf/0xba1
       [<c0448b28>] __lock_acquire+0x6a4/0x73c
       [<c0449d40>] lock_acquire+0xa8/0xc8
       [<c047f040>] might_fault+0x52/0x72
       [<c0548f7d>] copy_to_user+0x28/0x3f
       [<c049bd9b>] fiemap_fill_next_extent+0x9e/0xc9
       [<c04f2aef>] ext4_ext_fiemap_cb+0x1a7/0x1c1
       [<c04f1cdd>] ext4_ext_walk_space+0x194/0x207
       [<c04f2fb4>] ext4_fiemap+0x17c/0x191
       [<c049c157>] do_vfs_ioctl+0x32a/0x4a6
       [<c049c313>] sys_ioctl+0x40/0x5a
       [<c0402944>] sysenter_do_call+0x12/0x32
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

1 lock held by a.out/5595:
 #0:  (&ei->i_data_sem){++++..}, at: [<c04f2f71>] ext4_fiemap+0x139/0x191

stack backtrace:
Pid: 5595, comm: a.out Not tainted 2.6.30-rc4-autokern1 #1
Call Trace:
 [<c04477e0>] print_circular_bug_tail+0xab/0xb6
 [<c0447eb2>] validate_chain+0x5cf/0xba1
 [<c0448b28>] __lock_acquire+0x6a4/0x73c
 [<c0449d40>] lock_acquire+0xa8/0xc8
 [<c047f023>] ? might_fault+0x35/0x72
 [<c047f040>] might_fault+0x52/0x72
 [<c047f023>] ? might_fault+0x35/0x72
 [<c0548f7d>] copy_to_user+0x28/0x3f
 [<c049bd9b>] fiemap_fill_next_extent+0x9e/0xc9
 [<c04f2aef>] ext4_ext_fiemap_cb+0x1a7/0x1c1
 [<c04f1cdd>] ext4_ext_walk_space+0x194/0x207
 [<c04f2fb4>] ext4_fiemap+0x17c/0x191
 [<c04f2948>] ? ext4_ext_fiemap_cb+0x0/0x1c1
 [<c049c157>] do_vfs_ioctl+0x32a/0x4a6
 [<c049c313>] sys_ioctl+0x40/0x5a
 [<c0402944>] sysenter_do_call+0x12/0x32
