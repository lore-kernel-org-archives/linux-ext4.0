From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Tue, 09 Jan 2018 09:12:33 +0000
Message-ID: <bug-198301-13602-YT5RIzuDmw@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50572 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751032AbeAIJMf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Jan 2018 04:12:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A163827FA9
        for <linux-ext4@vger.kernel.org>; Tue,  9 Jan 2018 09:12:34 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

Jan Kara (jack@suse.cz) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #1 from Jan Kara (jack@suse.cz) ---
Yes, this is a design limitation of ext4. In principle, on disk format of a
symlink could be extended to allow for larger symlinks but that would require
an incompatible on-disk format change and someone determined enough to
implement all this in the kernel, e2fsck, libext2fs, etc. Also the motivation
for the work is decreased by the fact that commonly deployed filesystems with
4k block size do not exhibit the problem. So I personally don't think fixing
this is worth the effort.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
