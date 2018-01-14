From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sun, 14 Jan 2018 00:06:39 +0000
Message-ID: <bug-198301-13602-yxGoTjtH49@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38836 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbeANAGk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 19:06:40 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DB65A28A89
        for <linux-ext4@vger.kernel.org>; Sun, 14 Jan 2018 00:06:39 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

--- Comment #6 from Josh Johnston (josh.johnston@hotmail.com) ---
Slight error above on step 8.  Should be:
$  mkdir -p [The long text above]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
