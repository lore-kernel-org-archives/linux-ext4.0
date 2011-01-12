From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Oops while going into hibernate
Date: Wed, 12 Jan 2011 14:48:58 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:47920 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab1ALNtB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jan 2011 08:49:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

while goning into hibernation right after resuming with
2.6.37-05668-g4162cf6 on S390 I get this one:

[  270.317785] PM: Basic memory bitmaps created
[  270.317789] PM: Syncing filesystems ...
[  270.318854] Unable to handle kernel pointer dereference at virtual kernel address           (null)
[  270.318865] Oops: 0004 [#1] PREEMPT SMP
[  270.318878] Modules linked in: binfmt_misc dm_multipath scsi_dh vmur [last unloaded: scsi_wait_scan]
[  270.318900] CPU: 0 Not tainted 2.6.37-05668-g4162cf6 #19
[  270.318907] Process flush-94:0 (pid: 1226, task: 000000003f0a0040, ksp: 000000003d75fc70)
[  270.318916] Krnl PSW : 0704000180000000 0000000000206662 (jbd2_journal_file_inode+0xfe/0x148)
[  270.318938]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
[  270.318948] Krnl GPRS: ffe62f366dac01a2 0000000000000000 0000000000000000 00000000007e4260
[  270.318961]            00000000002065dc 6880000000000000 000000003f234d60 0000000000000005
[  270.318971]            000000003f6e15a8 000000003d75fa88 000000003ed59228 000000003ed58c60
[  270.319105]            0000000000000000 000000003f036488 00000000002065dc 000000003d75f9a0
[  270.319123] Krnl Code: 0000000000206656: b9140022            lgfr    %r2,%r2
[  270.319133]            000000000020665a: 07f4                bcr     15,%r4
[  270.319145]            000000000020665c: ec260023007c        cgij    %r2,0,6,2066a2
[  270.319158]           >0000000000206662: e3d0c0000024        stg     %r13,0(%r12)
[  270.319181]            0000000000206668: 4110c010            la      %r1,16(%r12)
[  270.319198]            000000000020666c: e320d0600004        lg      %r2,96(%r13)
[  270.319241]            0000000000206672: e31020080024        stg     %r1,8(%r2)
[  270.319260]            0000000000206678: e320c0100024        stg     %r2,16(%r12)
[  270.319281] Call Trace:
[  270.319289] ([<00000000002065dc>] jbd2_journal_file_inode+0x78/0x148)
[  270.319303]  [<00000000001d0f66>] mpage_da_map_and_submit+0x2ea/0x440
[  270.319319]  [<00000000001d197a>] ext4_da_writepages+0x32e/0x744
[  270.319334]  [<000000000016fe64>] writeback_single_inode+0xd4/0x25c
[  270.319391]  [<0000000000170514>] writeback_sb_inodes+0xd0/0x160
[  270.319396]  [<0000000000171278>] writeback_inodes_wb+0x90/0x16c
[  270.319408]  [<00000000001715fa>] wb_writeback+0x2a6/0x480
[  270.319414]  [<00000000001718b6>] wb_do_writeback+0xe2/0x294
[  270.319419]  [<0000000000171b14>] bdi_writeback_thread+0xac/0x2fc
[  270.319424]  [<000000000007d192>] kthread+0xbe/0xc8
[  270.319457]  [<000000000047910a>] kernel_thread_starter+0x6/0xc
[  270.319467]  [<0000000000479104>] kernel_thread_starter+0x0/0xc

bisecting points to:

commit 8aefcd557d26d0023a36f9ec5afbf55e59f8f26b
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Jan 10 12:29:43 2011 -0500

    ext4: dynamically allocate the jbd2_inode in ext4_inode_info as necessary

    Replace the jbd2_inode structure (which is 48 bytes) with a pointer
    and only allocate the jbd2_inode when it is needed --- that is, when
    the file system has a journal present and the inode has been opened
    for writing.  This allows us to further slim down the ext4_inode_info
    structure.

Regards,
Sebastian
