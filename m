Return-Path: <SRS0=3Woa=SR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A2BC10F0E
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 07:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FAAD20833
	for <linux-ext4@archiver.kernel.org>; Mon, 15 Apr 2019 07:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfDOH6w convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 15 Apr 2019 03:58:52 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48992 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbfDOH6w (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Apr 2019 03:58:52 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E13DB28869
        for <linux-ext4@vger.kernel.org>; Mon, 15 Apr 2019 07:58:50 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D4E6D2888A; Mon, 15 Apr 2019 07:58:50 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 203317] New: WARNING: CPU: 2 PID: 925 at fs/ext4/inode.c:3897
 ext4_set_page_dirty+0x39/0x50
Date:   Mon, 15 Apr 2019 07:58:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: upfefferlein@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-203317-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203317

            Bug ID: 203317
           Summary: WARNING: CPU: 2 PID: 925 at fs/ext4/inode.c:3897
                    ext4_set_page_dirty+0x39/0x50
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.23
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: upfefferlein@gmail.com
        Regression: No

Created attachment 282335
  --> https://bugzilla.kernel.org/attachment.cgi?id=282335&action=edit
kernel config

I found #201631, but i am not on ppc-64 so creating a new ticket.

Apr 12 17:00:37 localhost kernel: [28248.756299] WARNING: CPU: 2 PID: 925 at
fs/ext4/inode.c:3897 ext4_set_page_dirty+0x39/0x50
Apr 12 17:00:37 localhost kernel: [28248.756300] Modules linked in: vboxpci(O)
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) iwlmvm x86_pkg_temp_thermal iwlwifi
Apr 12 17:00:37 localhost kernel: [28248.756309] CPU: 2 PID: 925 Comm: kswapd0
Tainted: G           O      4.19.23-gentoo #1
Apr 12 17:00:37 localhost kernel: [28248.756309] Hardware name: LENOVO
20FB006BGE/20FB006BGE, BIOS N1FET44W (1.18 ) 09/01/2016
Apr 12 17:00:37 localhost kernel: [28248.756312] RIP:
0010:ext4_set_page_dirty+0x39/0x50
Apr 12 17:00:37 localhost kernel: [28248.756313] Code: 48 8b 00 a8 01 75 16 48
8b 57 08 48 8d 42 ff 83 e2 01 48 0f 44 c7 48 8b 00 a8 10 74 0d 48 8b 07 f6 c4
10 74 0f e9 f7 8e f9 ff <0f> 0b 48 8b 07 f6 c4 10 75 f1 0f 0b e9 e6 8e f9 ff 66
0f 1f 44 00
Apr 12 17:00:37 localhost kernel: [28248.756314] RSP: 0018:ffffc9000331bb68
EFLAGS: 00010246
Apr 12 17:00:37 localhost kernel: [28248.756316] RAX: 020000000001006c RBX:
00000000003b964e RCX: 0000000000000000
Apr 12 17:00:37 localhost kernel: [28248.756317] RDX: 0000000000000000 RSI:
00000002ae380000 RDI: ffffea000ee59380
Apr 12 17:00:37 localhost kernel: [28248.756318] RBP: ffff8883ff6f1800 R08:
0000000000000000 R09: 0000000000000000
Apr 12 17:00:37 localhost kernel: [28248.756319] R10: 0000000000000000 R11:
ffff888403f9c000 R12: ffffea000ee59380
Apr 12 17:00:37 localhost kernel: [28248.756320] R13: ffff888073eed000 R14:
ffff888074529a80 R15: 0000000000000000
Apr 12 17:00:37 localhost kernel: [28248.756321] FS:  0000000000000000(0000)
GS:ffff888411300000(0000) knlGS:0000000000000000
Apr 12 17:00:37 localhost kernel: [28248.756322] CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Apr 12 17:00:37 localhost kernel: [28248.756323] CR2: 00007f4f5ecb21f8 CR3:
0000000003a0a006 CR4: 00000000003626e0
Apr 12 17:00:37 localhost kernel: [28248.756324] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 12 17:00:37 localhost kernel: [28248.756325] DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Apr 12 17:00:37 localhost kernel: [28248.756325] Call Trace:
Apr 12 17:00:37 localhost kernel: [28248.756330] 
i915_gem_userptr_put_pages+0x144/0x180
Apr 12 17:00:37 localhost kernel: [28248.756334] 
__i915_gem_object_put_pages+0x61/0x70
Apr 12 17:00:37 localhost kernel: [28248.756336]  i915_gem_shrink+0x2ab/0x4b0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
