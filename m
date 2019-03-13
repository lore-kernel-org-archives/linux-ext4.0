Return-Path: <SRS0=5sbL=RQ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F8EC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 17:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26FB2070D
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Mar 2019 17:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfCMR3Y convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:29:24 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60490 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfCMR3X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Mar 2019 13:29:23 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DC95D29770
        for <linux-ext4@vger.kernel.org>; Wed, 13 Mar 2019 17:29:22 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D073D2985A; Wed, 13 Mar 2019 17:29:22 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202877] failure at
 fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()!
Date:   Wed, 13 Mar 2019 17:29:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sandeen@sandeen.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-202877-13602-iaFCKoB7TG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202877-13602@https.bugzilla.kernel.org/>
References: <bug-202877-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202877

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #4 from Eric Sandeen (sandeen@sandeen.net) ---
I'm not eager to download and run a random 16MB binary blob.  What is this
"ext4-combined" utility?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
