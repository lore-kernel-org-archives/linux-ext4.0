From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sat, 13 Jan 2018 23:22:09 +0000
Message-ID: <bug-198301-13602-LURnW0LddS@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33880 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751168AbeAMXWL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 18:22:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3094228B0E
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jan 2018 23:22:11 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

Andreas Dilger (adilger.kernelbugzilla@dilger.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #3 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Hi Josh, did you actually test if this patch works with a symlink longer than a
single block?  

The existing slow symlink code is only written to handle a single block, so
just removing the check doesn't fix that. There would also need to be a new
INCOMPATIBLE feature flag added, so that the kernel and e2fsck know that there
are symlink a longer than a single block. Otherwise they would consider the
link corrupted.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
