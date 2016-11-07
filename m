From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Mon, 07 Nov 2016 17:02:34 +0000
Message-ID: <bug-187051-13602-GAemGwcP6u@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751982AbcKGRCj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 12:02:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id EFAEE200ED
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 17:02:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 2EF632025A
        for <linux-ext4@vger.kernel.org>; Mon,  7 Nov 2016 17:02:35 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
So /usr/share/help/oc/totem/figures is a *directory*?    A directory has no
business being on the orphan list, so something very strange is indeed going
on.

If this happens again, please using debugfs to get a stat of the inode in
question:

debugfs /dev/dm-0
debugfs: stat <54264316>

the timestamps in the inode might be helpful.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
