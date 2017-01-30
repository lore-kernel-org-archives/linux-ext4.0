From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Mon, 30 Jan 2017 16:53:01 +0000
Message-ID: <bug-193661-13602-p43ug13I5H@https.bugzilla.kernel.org/>
References: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753809AbdA3QxJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:53:09 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id BFAC020220
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:53:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 696702025B
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:53:01 +0000 (UTC)
In-Reply-To: <bug-193661-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
And since you appear to be the maintainer of the stress-ng package, while I'm
here, any objections if upload a backport of stress-ng v0.07.16 to
jessie-backports?  :-)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
