From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 10 Jul 2017 22:52:56 +0000
Message-ID: <bug-196223-13602-zvXwN0siij@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:60108 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754955AbdGJWw6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Jul 2017 18:52:58 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 93813283C3
        for <linux-ext4@vger.kernel.org>; Mon, 10 Jul 2017 22:52:57 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #19 from Theodore Tso (tytso@mit.edu) ---
The nvme failure followed by the ext4 I/O error warning makes it pretty clear
this is a storage device issue.  So the next question is whether all of your CI
hardware has nvme storage devices (in which case the problem might be in the
nvme device driver not handling suspend/resume)?   Or perhaps after the
suspend/resume something much more fundamental is getting screwed up (e.g.,
like interrupts getting disabled, or some such).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
