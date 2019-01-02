Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37094 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729749AbfABRW3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jan 2019 12:22:29 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1748C2856D
        for <linux-ext4@vger.kernel.org>; Wed,  2 Jan 2019 17:22:29 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 02 Jan 2019 17:22:28 +0000
Message-ID: <bug-198187-13602-HgwzyGZbil@https.bugzilla.kernel.org/>
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

--- Comment #14 from Jan Kara (jack@suse.cz) ---
Well, the reason for jbd2 thread staying for long in
jbd2_journal_commit_transaction() can be simply a busy disk. So without more
details it's difficult to tell whether you are really facing the same issue. So
which processes are hung, does the hang eventually resolve itself or is reboot
needed? Please provide sysrq-w output from dmesg when the system is hung.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
