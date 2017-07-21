From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Fri, 21 Jul 2017 21:47:03 +0000
Message-ID: <bug-196405-13602-wftPX4kXg1@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58250 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752091AbdGUVrG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Jul 2017 17:47:06 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 90426285EA
        for <linux-ext4@vger.kernel.org>; Fri, 21 Jul 2017 21:47:05 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #21 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Michael, as discussed here, I don't think the problem is the number of links,
but rather that fts is "optimizing" the traversal of a directory with a hard
link count of 1 incorrectly.  In your debbugs.gnu.org 27739 bug report this
problem wasn't mentioned at all, only that the link count was set to 1, which
is why I think it was closed as "not a bug".

I would suggest to re-open 27739, or file a new bug that describes the problem
as Paul did in the first comment here, namely that fts is incorrectly
optimizing the traversal of subdirectories when the directory link count is 1,
when it should be treating this as "the subdirectory count is not being
tracked".

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
