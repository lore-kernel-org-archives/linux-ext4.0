Return-Path: <SRS0=Pl0f=DB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCB7C4363D
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 00:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D93F92145D
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Sep 2020 00:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIXASL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXASL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Sep 2020 20:18:11 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 209275] Graphics freeze after WARNING: CPU: 2 PID: 156207 at
 fs/ext4/inode.c:3599 ext4_set_page_dirty+0x3e/0x50
Date:   Thu, 24 Sep 2020 00:18:10 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rhmcruiser@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209275-13602-tAeXlteGn2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209275-13602@https.bugzilla.kernel.org/>
References: <bug-209275-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209275

--- Comment #5 from Monthero Ronald (rhmcruiser@gmail.com) ---
(In reply to Dennis Wagelaar from comment #3)
> The core dumps for gnome-shell stop after disabling shell extensions. These
> core dumps can be reliably triggered for both gnome-shell with extensions
> and firefox by putting the system into S3 sleep and waking it back up
> (something I do multiple times per day).
> 
> I upgraded to kernel 5.8.9-101.fc31.x86_64 this morning. I'll report back
> whether this issue persists or not.

Hi Dennis, 
Yes its quite indicative that the gnome-shell hang (graphics and input) and
repeated core dumps of gnome-shell were triggering this behavior.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
