Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3328C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 00:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B242920854
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 00:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfCNAnR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 20:43:17 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44230 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbfCNAnQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Mar 2019 20:43:16 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9208B2A0A7
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 00:43:15 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 908F22A0AA; Thu, 14 Mar 2019 00:43:15 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202879] Segmentation fault while running crafted program
Date:   Thu, 14 Mar 2019 00:43:13 +0000
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
Message-ID: <bug-202879-13602-XWaAmVffIR@https.bugzilla.kernel.org/>
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

Jungyeon (jungyeon@gatech.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|5.0-rc8                     |5.0.0

--- Comment #6 from Jungyeon (jungyeon@gatech.edu) ---
Sorry for my lack of explanation. 
Yes, LKL is Linux Kernel Library. poc-01.c is a program that calls lists of
system calls in userspace and the craft image is a potentially faulty image to
test error cases.

We are going to release our source code so that you can build the ext4-combined
shortly. We needs some clean-up inside the codes before making it public.

I'm attaching stack dump at the last.
The problem here is that bh is NULL at the first place of this function, so
that it leads to an error on J_ASSERT_JH(jh, jh->b_jcount >= 0).
To get the stack dump, I temporarily inserted BUG_ON on condition of jh being
NULL.

Additionally I used Linux version 5.0.0+ for this trace (and in the linked
ext4-combined binary)

2534 static void __journal_remove_journal_head(struct buffer_head *bh)
2535 {
2536     struct journal_head *jh = bh2jh(bh);
2537 
2538     BUG_ON(jh == NULL);
2539     J_ASSERT_JH(jh, jh->b_jcount >= 0);
2540     J_ASSERT_JH(jh, jh->b_transaction == NULL);
2541     J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
2542     J_ASSERT_JH(jh, jh->b_cp_transaction == NULL);
2543     J_ASSERT_JH(jh, jh->b_jlist == BJ_None);
2544     J_ASSERT_BH(bh, buffer_jbd(bh));
2545     J_ASSERT_BH(bh, jh2bh(jh) == bh);
2546     BUFFER_TRACE(bh, "remove journal_head");
2547     if (jh->b_frozen_data) {
2548         printk(KERN_WARNING "%s: freeing b_frozen_data\n", __func__);
2549         jbd2_free(jh->b_frozen_data, bh->b_size);
2550     }


- Stack dump
[    0.089081] BUG: failure at
fs/jbd2/journal.c:2538/__journal_remove_journal_head()!
[    0.089096] Kernel panic - not syncing: BUG!
[    0.089101] Call Trace:
[    0.089110] (____ptrval____):  [<55555559bc94>] .LC81+0x5f/0xfb
[    0.089118] (____ptrval____):  [<5555555c6025>] major_names+0x75/0x80
[    0.089125] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.089133] (____ptrval____):  [<5555556b1e40>] submit_bh+0x40/0x50
[    0.089141] (____ptrval____):  [<55555580286d>]
jbd2_journal_put_journal_head+0x6cd/0x6d0
[    0.089147] (____ptrval____):  [<5555557ec6e8>]
__jbd2_journal_refile_buffer+0x2d8/0x3c0
[    0.089153] (____ptrval____):  [<5555557f641a>]
__jbd2_journal_remove_checkpoint+0x17a/0x2f0
[    0.089164] (____ptrval____):  [<5555557eff12>]
jbd2_journal_commit_transaction+0x2fc2/0x3fc0
[    0.089173] (____ptrval____):  [<555555597353>] .LC18+0x3/0x10
[    0.089181] (____ptrval____):  [<5555555b8fb9>] try_to_wake_up+0x169/0x190
[    0.089190] (____ptrval____):  [<5555558031be>] kjournald2+0x34e/0x400
[    0.089199] (____ptrval____):  [<5555555bfd30>]
autoremove_wake_function+0x0/0x40
[    0.089206] (____ptrval____):  [<5555555978f4>] .LC11+0x14/0x20
[    0.089214] (____ptrval____):  [<5555555b3acb>] kthread+0x15b/0x170
[    0.089221] (____ptrval____):  [<555555802e70>] kjournald2+0x0/0x400
[    0.089228] (____ptrval____):  [<5555555b3970>] kthread+0x0/0x170
[    0.089237] (____ptrval____):  [<5555555970ab>] uidhash_table+0x3b/0x40

Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
