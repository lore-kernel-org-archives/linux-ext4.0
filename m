From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 172741] create year being set as 2014 and not 2016
Date: Fri, 23 Sep 2016 01:05:39 +0000
Message-ID: <bug-172741-13602-oUTZKHQmop@https.bugzilla.kernel.org/>
References: <bug-172741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbcIWBFn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 22 Sep 2016 21:05:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 01D76203ED
        for <linux-ext4@vger.kernel.org>; Fri, 23 Sep 2016 01:05:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 0D73F2041B
        for <linux-ext4@vger.kernel.org>; Fri, 23 Sep 2016 01:05:40 +0000 (UTC)
In-Reply-To: <bug-172741-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=172741

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Can you reliably reproduce this and are you sure the system time was set
correctly?

If so, please give us your reproduction instructions.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
