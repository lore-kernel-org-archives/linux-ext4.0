From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Mon, 24 Jul 2017 18:48:05 +0000
Message-ID: <bug-196405-13602-dlroWt13CZ@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51444 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753577AbdGXSsM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Jul 2017 14:48:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id AE122283CF
        for <linux-ext4@vger.kernel.org>; Mon, 24 Jul 2017 18:48:11 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #25 from michelbach94@gmail.com ---
(In reply to Theodore Tso from comment #24)

There are a couple of things I think you should change.

• Writing the number as "65'000" (fast to read and unambiguous to everyone) or
"65 000" (SI style) would be better.
• The comma after the introductory adverb "Normally" is missing.
• "to regular files as well as directories" instead of "to files as well as
directories". Remember: Directories are files.
• Thousands separator, again.
• If you choose to mention '..', mention '.', too. Or mention neither, idc.
• It called a "link count", not a "links count".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
