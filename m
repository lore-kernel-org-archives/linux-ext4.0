Return-Path: <SRS0=9fVA=22=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1463C33C8C
	for <linux-ext4@archiver.kernel.org>; Sun,  5 Jan 2020 22:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 967C421582
	for <linux-ext4@archiver.kernel.org>; Sun,  5 Jan 2020 22:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgAEWIy convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 5 Jan 2020 17:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEWIy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 5 Jan 2020 17:08:54 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 205957] Ext4 64 bit hash breaks 32 bit glibc 2.28+
Date:   Sun, 05 Jan 2020 22:08:52 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glaubitz@physik.fu-berlin.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205957-13602-QsY9QIlVr0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205957-13602@https.bugzilla.kernel.org/>
References: <bug-205957-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205957

--- Comment #14 from John Paul Adrian Glaubitz (glaubitz@physik.fu-berlin.de) ---
Thanks for working on this! I think the suffix _x32 might be misleading as this
is the name of the 32-bit ABI on x86_64, see:
https://en.wikipedia.org/wiki/X32_ABI.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
