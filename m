Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D574BC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 18:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF1D020811
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 18:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfCNSPL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:15:11 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56716 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726531AbfCNSPL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 14:15:11 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A20A62A50F
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 18:15:09 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id A06FF2A4D1; Thu, 14 Mar 2019 18:15:09 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202879] Segmentation fault while running crafted program
Date:   Thu, 14 Mar 2019 18:15:08 +0000
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
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-202879-13602-huq5maHyWt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202879-13602@https.bugzilla.kernel.org/>
References: <bug-202879-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202879

--- Comment #7 from Jungyeon (jungyeon@gatech.edu) ---
Created attachment 281825
  --> https://bugzilla.kernel.org/attachment.cgi?id=281825&action=edit
another test set

I'm attaching another error case what shows the same failure.
This includes much less system call (15 calls) so I hope this can help to
figure out this bug.

- Reproduce
./lkl/tools/lkl/ext4-combined -t ext4 -i tmp.img -p min_11.c.raw -v
(min_11.c shows it's internal programs)

- Call stack
[    0.040743] BUG: failure at
fs/jbd2/journal.c:2538/__journal_remove_journal_head()!
[    0.040754] Kernel panic - not syncing: BUG!
[    0.040758] Call Trace:
[    0.040767] (____ptrval____):  [<55555559bc94>] .LC81+0x5f/0xfb
[    0.040775] (____ptrval____):  [<5555555c6025>] major_names+0x75/0x80
[    0.040782] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.040791] (____ptrval____):  [<555555604368>] kmem_cache_free+0x148/0x190
[    0.040796] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.040804] (____ptrval____):  [<55555580286d>]
jbd2_journal_put_journal_head+0x6cd/0x6d0
[    0.040811] (____ptrval____):  [<5555557f641a>]
__jbd2_journal_remove_checkpoint+0x17a/0x2f0
[    0.040822] (____ptrval____):  [<5555557f5608>]
jbd2_log_do_checkpoint+0x298/0xd10
[    0.040835] (____ptrval____):  [<555555850674>] atomic64_cmpxchg+0x54/0x80
[    0.040843] (____ptrval____):  [<5555557feda3>]
jbd2_journal_destroy+0x363/0x840
[    0.040856] (____ptrval____):  [<5555555bfd30>]
autoremove_wake_function+0x0/0x40
[    0.040865] (____ptrval____):  [<5555555ada2c>] input_timer_state+0x1c/0x20
[    0.040873] (____ptrval____):  [<5555557cb8ac>] ext4_put_super+0xac/0x7f0
[    0.040881] (____ptrval____):  [<555555616f5b>]
generic_shutdown_super+0x13b/0x370
[    0.040889] (____ptrval____):  [<55555561acc5>] kill_block_super+0x55/0x100
[    0.040897] (____ptrval____):  [<555555616abc>]
deactivate_locked_super+0x11c/0x170
[    0.040903] (____ptrval____):  [<555555616cb6>] deactivate_super+0x1a6/0x1b0
[    0.040911] (____ptrval____):  [<5555556538fb>] dput+0xcb/0x7c0
[    0.040919] (____ptrval____):  [<55555567d1a9>] cleanup_mnt+0xb9/0x170
[    0.040929] (____ptrval____):  [<55555567d0ed>] __cleanup_mnt+0x3d/0x40
[    0.040935] (____ptrval____):  [<5555555b24ca>] task_work_run+0xba/0xf0
[    0.040944] (____ptrval____):  [<55555559800f>] .LC2+0x3f/0x40
[    0.040951] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.040958] (____ptrval____):  [<5555555986d6>] .LC19+0x6/0x15
[    0.040966] 
[    0.040972] ---[ end Kernel panic - not syncing: BUG! ]---
ext4-combined: lib/posix-host.c:302: panic: Assertion `0' failed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
