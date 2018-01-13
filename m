From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sat, 13 Jan 2018 23:30:03 +0000
Message-ID: <bug-198301-13602-bsaye9EFGw@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34272 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751960AbeAMXaE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 18:30:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1BBE928AFC
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jan 2018 23:30:04 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

--- Comment #4 from Josh Johnston (josh.johnston@hotmail.com) ---
Andreas, I did test it and it appeared to work: I could create and follow the
symlink where I received the error before.  I'll take another look to make sure
I was doing what I think I was doing.

If you could give me a pointer to where the kernel and e2fsck expect the
symlink to fit in one block, that would be a great help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
