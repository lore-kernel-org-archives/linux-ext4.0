Return-Path: <SRS0=5sbL=RQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96512C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 17:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64F802075C
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 17:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCMRlf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:41:35 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38942 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbfCMRlf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Mar 2019 13:41:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0C32829FA4
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2019 17:41:35 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id F298229FA5; Wed, 13 Mar 2019 17:41:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202879] Segmentation fault while running crafted program
Date:   Wed, 13 Mar 2019 17:41:33 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202879-13602-GsmLcUB29t@https.bugzilla.kernel.org/>
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

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #5 from Theodore Tso (tytso@mit.edu) ---
I assume LKL is "Linux Kernel Library", so this is trying to run the ext4 file
system executing the system calls found in poc-01.c in userspace?

Are there instructions so we can build the ext4_combined from source?  That's
going to be needed if we are going to be able to run the binary under a
debugger, and versus a patched kernel to verify the fix.

Also, can you give us a stack dump so we might have some kind of hint what's
going on?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
