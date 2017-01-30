From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193661] xattr  ext4_xattr_block_find, bad block on cleanly
 formatted ext4 partition
Date: Mon, 30 Jan 2017 16:48:08 +0000
Message-ID: <bug-193661-13602-qC1NepZVVG@https.bugzilla.kernel.org/>
References: <bug-193661-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdA3QsM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 11:48:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7F3B620274
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:48:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 9D8D32025B
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 16:48:08 +0000 (UTC)
In-Reply-To: <bug-193661-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193661

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
Thanks for the bug report!

Does this require using the latest version of stress-ng (from the git tree), or
is it reproducible using the version of stress-ng in Ubuntu or Debian Jessie?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
