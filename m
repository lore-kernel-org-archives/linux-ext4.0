Return-Path: <SRS0=Ozrj=P6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5727BC282C3
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 23:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A0121726
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Jan 2019 23:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfAVXJb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Jan 2019 18:09:31 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39492 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbfAVXJb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Jan 2019 18:09:31 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B1472B34E
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jan 2019 23:09:31 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id F384A2B458; Tue, 22 Jan 2019 23:09:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 22 Jan 2019 23:09:29 +0000
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
Message-ID: <bug-201631-13602-vBinhwA29Q@https.bugzilla.kernel.org/>
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

--- Comment #45 from erhard_f@mailbox.org ---
(In reply to Jan Kara from comment #44)
> OK, new version of the debug patch that also tracks when last PTE for a page
> got set and dumps some more information about VMA and the page. Please
> report what the kernel prints now. Thanks a lot!

Thanks for being persistent though this bug does not seem to affect many
people!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
