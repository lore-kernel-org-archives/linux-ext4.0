Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE0BC169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 12:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF31C2086C
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 12:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfA2MNP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:13:15 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41380 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbfA2MNP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 07:13:15 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 62E492B263
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 12:13:14 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 610372BFC0; Tue, 29 Jan 2019 12:13:14 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 29 Jan 2019 12:13:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: erhard_f@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201631-13602-qgBDFO48LX@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201631-13602@https.bugzilla.kernel.org/>
References: <bug-201631-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=201631

--- Comment #56 from erhard_f@mailbox.org ---
(In reply to Jan Kara from comment #55)
> Created attachment 280841 [details]
> mm: Dump page and PTE state and some history (v5)
> 
> Erhard, please test with this debug patch. Thanks!

I would, but the patch does not apply against -rc4. ;)

/usr/src/linux-5.0-rc4 # patch -p1 < mm.patch 
patching file fs/ext4/file.c
patching file fs/ext4/inode.c
Hunk #3 succeeded at 3933 (offset 1 line).
Hunk #4 succeeded at 6327 (offset 26 lines).
patching file include/linux/buffer_head.h
patching file mm/memory.c
Hunk #2 succeeded at 1081 (offset -1 lines).
Hunk #6 succeeded at 3253 (offset 23 lines).
patching file mm/page_vma_mapped.c
patching file mm/rmap.c
Hunk #3 succeeded at 894 with fuzz 2.
Hunk #4 FAILED at 902.
Hunk #5 succeeded at 921 (offset 2 lines).
Hunk #6 succeeded at 979 (offset 2 lines).
1 out of 6 hunks FAILED -- saving rejects to file mm/rmap.c.rej

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
