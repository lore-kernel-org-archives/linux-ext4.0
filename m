From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194071] data loss using fallocate and mmap
Date: Thu, 25 May 2017 11:55:53 +0000
Message-ID: <bug-194071-13602-osXuMoVu6i@https.bugzilla.kernel.org/>
References: <bug-194071-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41786 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935583AbdEYLzy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 May 2017 07:55:54 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2600B27F4B
        for <linux-ext4@vger.kernel.org>; Thu, 25 May 2017 11:55:54 +0000 (UTC)
In-Reply-To: <bug-194071-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194071

--- Comment #4 from Jan Kara (jack@suse.cz) ---
BTW, can I base a testcase for fstests on your example program?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
