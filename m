From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sat, 13 Jan 2018 19:49:16 +0000
Message-ID: <bug-198301-13602-wv0g5CoUfT@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:35770 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751217AbeAMTtS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 14:49:18 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D77D328B2D
        for <linux-ext4@vger.kernel.org>; Sat, 13 Jan 2018 19:49:17 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

Josh Johnston (josh.johnston@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |josh.johnston@hotmail.com

--- Comment #2 from Josh Johnston (josh.johnston@hotmail.com) ---
Created attachment 273589
  --> https://bugzilla.kernel.org/attachment.cgi?id=273589&action=edit
Proposed patch

Here's a proposed patch.  When the symlink's path length is longer than a
block, it uses the existing code to fall back on a slow symlink.  This is the
better behavior, rather than throwing an error.


Block size should only be a limitation on the path if using a fast symlink,
which includes the path in the inode.  More info on fast/slow symlinks at:

https://unix.stackexchange.com/questoins/147535/fast-and-slow-symlinks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
