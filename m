From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198187] jbd2_log_wait_commit hangs
Date: Wed, 24 Jan 2018 10:02:36 +0000
Message-ID: <bug-198187-13602-1S1erASbtT@https.bugzilla.kernel.org/>
References: <bug-198187-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35184 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752320AbeAXKCj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 24 Jan 2018 05:02:39 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 27C7B288A3
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jan 2018 10:02:39 +0000 (UTC)
In-Reply-To: <bug-198187-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198187

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |snitzer@redhat.com

--- Comment #11 from Jan Kara (jack@suse.cz) ---
Thanks. Mike, any idea here? It appears JBD2 submitted IO to dm-raid1 and it
never completed. Apparently this did not happen with 4.12.8 but it does happen
relatively regularly with 4.13.8...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
