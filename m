Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168F6C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 09:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D794E2082E
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 09:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfA2JlD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:41:03 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42976 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbfA2JlD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Jan 2019 04:41:03 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ADA332B3AF
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:41:02 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id A1B302B39C; Tue, 29 Jan 2019 09:41:02 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 201631] WARNING: CPU: 11 PID: 29593 at fs/ext4/inode.c:3927
 .ext4_set_page_dirty+0x70/0xb0
Date:   Tue, 29 Jan 2019 09:41:02 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jack@suse.cz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-201631-13602-6jrXLtn6cG@https.bugzilla.kernel.org/>
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

--- Comment #55 from Jan Kara (jack@suse.cz) ---
Created attachment 280841
  --> https://bugzilla.kernel.org/attachment.cgi?id=280841&action=edit
mm: Dump page and PTE state and some history (v5)

Erhard, please test with this debug patch. Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
