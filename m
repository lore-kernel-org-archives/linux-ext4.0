From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Mon, 30 Jan 2017 16:08:57 +0000
Message-ID: <bug-193661-13602-MJwOtAsT6f@https.bugzilla.kernel.org/>
References: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdA3QJB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:09:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id EC22C20256
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:08:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 71AEF2026C
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:08:57 +0000 (UTC)
In-Reply-To: <bug-193661-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

--- Comment #1 from Colin Ian King <colin.king@canonical.com> ---
Forgot to mention, this can be triggered on a SMP ppc64el VM with 4.8, but far
less frequently than the i386.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
