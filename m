From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] inline_data + journal_data == segfaults/buserrors in
 userspace mmap
Date: Mon, 30 Jan 2017 15:58:19 +0000
Message-ID: <bug-193431-13602-NRFXWJHoLQ@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932144AbdA3P6X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 10:58:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id DD1BC202B8
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 15:58:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id E5D3E20256
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 15:58:19 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
It may be a real problem, but if it isn't ext4 specific, you're reporting it to
the wrong place and we won't be able to help you.

Userspace crashes tend to be caused by (surprise!) userspace bugs, and this the
kernel bugzilla.   If you can trim this down to something which makes it clear
that it is ext4 specific issue please feel free to update this bug with this
new information.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
