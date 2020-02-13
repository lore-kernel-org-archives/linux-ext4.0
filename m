Return-Path: <SRS0=bpHE=4B=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D22BC2BA83
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 09:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61000217F4
	for <linux-ext4@archiver.kernel.org>; Thu, 13 Feb 2020 09:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgBMJDt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgBMJDs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Feb 2020 04:03:48 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 104311] Out of bounds read in test suite of e2fsprogs
Date:   Thu, 13 Feb 2020 09:03:48 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext2@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext2
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hanno@hboeck.de
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext2@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-104311-13602-3924Hgq8XU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-104311-13602@https.bugzilla.kernel.org/>
References: <bug-104311-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=104311

Hanno Boeck (hanno@hboeck.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #1 from Hanno Boeck (hanno@hboeck.de) ---
Fixed in
https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git/commit/lib/ext2fs/tst_badblocks.c?id=f449486d631987983b4275d246b7bbbb551f3235

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
