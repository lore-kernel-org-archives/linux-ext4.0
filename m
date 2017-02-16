From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194607] Unable to change passwd upon a hard reboot
Date: Thu, 16 Feb 2017 15:05:28 +0000
Message-ID: <bug-194607-13602-03MEzrGzwL@https.bugzilla.kernel.org/>
References: <bug-194607-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:58012 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932448AbdBPPFs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Feb 2017 10:05:48 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DC4BA28602
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2017 15:05:47 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1A13628602
        for <linux-ext4@vger.kernel.org>; Thu, 16 Feb 2017 15:05:47 +0000 (UTC)
In-Reply-To: <bug-194607-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194607

--- Comment #1 from Ramana Reddy (ramanareddy1892@gmail.com) ---
Also there is no ssh session runnning. Only serial console is active. So there
is only one instance of passwd being exceuted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
