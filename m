From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Wed, 12 Jul 2017 07:52:32 +0000
Message-ID: <bug-196223-13602-hj2fEFj9dO@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49756 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756753AbdGLHwe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Jul 2017 03:52:34 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4D7B0285F5
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jul 2017 07:52:33 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #25 from Tomi Sarvela (tomi.p.sarvela@intel.com) ---
Shortest testlist I could find to reproduce the issue with is

scsi-mq.testlist:
igt@gem_exec_gttfill@basic
igt@gem_exec_suspend@basic-s3

Ran with ./scripts/run-tests.sh -vT scsi-mq.testlist

Using kernel option scsi_mod.use_blk_mq=0 makes this testlist pass.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
