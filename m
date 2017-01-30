From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Mon, 30 Jan 2017 16:24:02 +0000
Message-ID: <bug-193661-13602-L6FqxX6ZVS@https.bugzilla.kernel.org/>
References: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932446AbdA3QYJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:24:09 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 1978F202B8
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:24:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id BCE1B202E5
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:24:02 +0000 (UTC)
In-Reply-To: <bug-193661-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

--- Comment #3 from Colin Ian King <colin.king@canonical.com> ---
For reference, the xattr stressor is:
http://kernel.ubuntu.com/git/cking/stress-ng.git/tree/stress-xattr.c

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
