From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193431] inline_data + journal_data == segfaults/buserrors in
 userspace mmap
Date: Mon, 30 Jan 2017 11:11:40 +0000
Message-ID: <bug-193431-13602-VSB8RzJkFH@https.bugzilla.kernel.org/>
References: <bug-193431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750984AbdA3LUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 06:20:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 225E920268
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 11:11:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 3EDF320256
        for <linux-ext4@vger.kernel.org>; Mon, 30 Jan 2017 11:11:40 +0000 (UTC)
In-Reply-To: <bug-193431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=193431

Peter Rabbitson <rabbit@rabbit.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|512 byte inodes +           |inline_data + journal_data
                   |inline_data + journal_data  |== segfaults/buserrors in
                   |== segfaults/buserrors in   |userspace mmap
                   |userspace mmap              |

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
