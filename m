Return-Path: <SRS0=C+hA=QO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46939C282C2
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 22:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F9CB2173B
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Feb 2019 22:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfBGWf1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:35:27 -0500
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56536 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbfBGWf1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2019 17:35:27 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D4D4E2E086
        for <linux-ext4@vger.kernel.org>; Thu,  7 Feb 2019 22:35:26 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D2F3A2E754; Thu,  7 Feb 2019 22:35:26 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202269] kernel BUG at fs/buffer.c:3374!
Date:   Thu, 07 Feb 2019 22:35:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: selk@dragora.org
X-Bugzilla-Status: NEEDINFO
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202269-13602-mmpXvkNhOx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202269-13602@https.bugzilla.kernel.org/>
References: <bug-202269-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202269

--- Comment #2 from Matias A. Fonzo (selk@dragora.org) ---
Hello,

I don't think this is reproducible, because later I discover it was troubles
with the memory, it was related to the BIOS configuration, I've set the
frequency for the memory manually, and it is working well for now.

Specifically, what do you know about the setup?.

Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
