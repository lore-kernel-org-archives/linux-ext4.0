Return-Path: <SRS0=Qk7k=Y4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C2CCA9EB5
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 14:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7CF6218BA
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Nov 2019 14:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfKDOwB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Nov 2019 09:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbfKDOwB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 4 Nov 2019 09:52:01 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205417] Files corruption ( fs/ext4/inode.c:3941
 ext4_set_page_dirty+0x3e/0x50 [ext4] )
Date:   Mon, 04 Nov 2019 14:52:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: the.dmol@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-205417-13602-daRWSCvJuS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205417-13602@https.bugzilla.kernel.org/>
References: <bug-205417-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205417

--- Comment #2 from Ivan Baidakou (the.dmol@gmail.com) ---
Created attachment 285781
  --> https://bugzilla.kernel.org/attachment.cgi?id=285781&action=edit
/var/log/messages before I powered it off

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
