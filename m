Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEACC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 18:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E82F8217F5
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 18:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfCNSrM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:47:12 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35462 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727092AbfCNSrM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 14:47:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 29DF92A6BD
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 18:47:11 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 1E4F62A6BC; Thu, 14 Mar 2019 18:47:11 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202877] failure at
 fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()!
Date:   Thu, 14 Mar 2019 18:47:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jungyeon@gatech.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-202877-13602-WR8mTAibpF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202877-13602@https.bugzilla.kernel.org/>
References: <bug-202877-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202877

Jungyeon (jungyeon@gatech.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.0.0-rc6                   |5.0.0

--- Comment #5 from Jungyeon (jungyeon@gatech.edu) ---
Sorry for my lack of explanation. 
LKL is Linux Kernel Library. min_02.c is a program that calls lists of system
calls in userspace and the craft image is a potentially faulty image to test
error cases.

We are going to release our source code so that you can build the ext4-combined
shortly. We needs some clean-up inside the codes before making it public.

I'm attaching stack dump at the last. I hope this could help you.
Additionally I used Linux version 5.0.0+ for this trace (and in the linked
ext4-combined binary)

[    0.050478] BUG: failure at
fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()!
[    0.050491] Kernel panic - not syncing: BUG!
[    0.050497] Call Trace:
[    0.050506] (____ptrval____):  [<55555559bc94>] .LC81+0x5f/0xfb
[    0.050514] (____ptrval____):  [<5555555c6025>] major_names+0x75/0x80
[    0.050523] (____ptrval____):  [<555555604368>] kmem_cache_free+0x148/0x190
[    0.050533] (____ptrval____):  [<5555556aabff>] free_buffer_head+0x7f/0x190
[    0.050541] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.050551] (____ptrval____):  [<5555557f08db>]
jbd2_journal_commit_transaction+0x398b/0x3fc0
[    0.050559] (____ptrval____):  [<555555597353>] .LC18+0x3/0x10
[    0.050568] (____ptrval____):  [<5555555b8fb9>] try_to_wake_up+0x169/0x190
[    0.050577] (____ptrval____):  [<5555558031be>] kjournald2+0x34e/0x400
[    0.050586] (____ptrval____):  [<5555555bfd30>]
autoremove_wake_function+0x0/0x40
[    0.050593] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.050601] (____ptrval____):  [<5555555b3acb>] kthread+0x15b/0x170
[    0.050608] (____ptrval____):  [<555555802e70>] kjournald2+0x0/0x400
[    0.050615] (____ptrval____):  [<5555555b3970>] kthread+0x0/0x170
[    0.050623] (____ptrval____):  [<5555555970ab>] uidhash_table+0x3b/0x40
[    0.050630] 
[    0.050642] ---[ end Kernel panic - not syncing: BUG! ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
