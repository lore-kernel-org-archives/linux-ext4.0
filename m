From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194071] data loss using fallocate and mmap
Date: Tue, 05 Sep 2017 10:02:27 +0000
Message-ID: <bug-194071-13602-tw25Em5KHr@https.bugzilla.kernel.org/>
References: <bug-194071-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40446 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750755AbdIEKCg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Sep 2017 06:02:36 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7F6EC28922
        for <linux-ext4@vger.kernel.org>; Tue,  5 Sep 2017 10:02:36 +0000 (UTC)
In-Reply-To: <bug-194071-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194071

--- Comment #5 from Michael Zimmer (michael@swarm64.com) ---
Thanks for investigating and making the patch. Sorry that I missed your last
comment, feel free to base a testcase on the example program.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
