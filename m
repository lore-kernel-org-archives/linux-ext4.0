Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8640DC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 03:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DEE62082C
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 03:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfCYDl2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 24 Mar 2019 23:41:28 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37600 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729298AbfCYDl2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 24 Mar 2019 23:41:28 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B9EE029238
        for <linux-ext4@vger.kernel.org>; Mon, 25 Mar 2019 03:41:27 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id AD2CC2923E; Mon, 25 Mar 2019 03:41:27 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202879] Segmentation fault while running crafted program
Date:   Mon, 25 Mar 2019 03:41:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: tytso@mit.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-202879-13602-xy6l2WWyEL@https.bugzilla.kernel.org/>
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

--- Comment #9 from Theodore Tso (tytso@mit.edu) ---
Created attachment 281995
  --> https://bugzilla.kernel.org/attachment.cgi?id=281995&action=edit
possible patch to detect the problem early

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
