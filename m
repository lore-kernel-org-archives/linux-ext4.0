From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Mon, 07 Nov 2016 19:39:26 +0000
Message-ID: <bug-187051-13602-dGU39rtkWZ@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751203AbcKGTja (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 14:39:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 4447D20263
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 19:39:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 56E2520219
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 19:39:27 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
If it happens again, my suggestion would be to capture as much information
again, and then just reboot the system.   You can fsck the file system if you
are feeling especially paranoid, but it's likely that any corruption in data
structures are in-memory only.   That being said, the in-memory corruptions
could cause other corruptions that could eventually corrupt data or metadata. 
So rebooting right away would be a good idea.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
