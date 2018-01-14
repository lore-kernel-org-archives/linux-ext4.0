From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198301] ext4 fails to create symlink if target length is
 greater than block size (but smaller than PATH_MAX)
Date: Sun, 14 Jan 2018 00:16:34 +0000
Message-ID: <bug-198301-13602-lXUh7ZKLl7@https.bugzilla.kernel.org/>
References: <bug-198301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41992 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751190AbeANAQf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 19:16:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5A43928A29
        for <linux-ext4@vger.kernel.org>; Sun, 14 Jan 2018 00:16:35 +0000 (UTC)
In-Reply-To: <bug-198301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198301

Eric Biggers (ebiggers3@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ebiggers3@gmail.com

--- Comment #7 from Eric Biggers (ebiggers3@gmail.com) ---
> The strange side effect of this bug is that one can not link to every file in
> a file system with a block size of e.g. 1k while PATH_MAX is 4k.

Note that you cannot necessarily link to every file in the filesystem even with
a 4k block size, since the absolute path to a file can be over PATH_MAX. 
PATH_MAX is a limit on the path string passed to syscalls, not a limit on the
directory structure.  By using cwd-relative paths, fd-relative paths, chroots,
or bind mounts, you can create a directory structure that is much deeper than
PATH_MAX.  None of the major Linux filesystems enforce a directory depth limit,
as far as I know -- and even if one did, it could still be mounted at a
mountpoint whose absolute path is already PATH_MAX, or close to it.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
