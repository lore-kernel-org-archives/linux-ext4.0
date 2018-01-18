From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198505] Errors from EXt4 FS when resuming from single
 hibernation image
Date: Thu, 18 Jan 2018 16:19:35 +0000
Message-ID: <bug-198505-13602-0UUukYOiQE@https.bugzilla.kernel.org/>
References: <bug-198505-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37160 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752746AbeARQTf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Jan 2018 11:19:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7A86D27C0B
        for <linux-ext4@vger.kernel.org>; Thu, 18 Jan 2018 16:19:35 +0000 (UTC)
In-Reply-To: <bug-198505-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=198505

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso (tytso@mit.edu) ---
This is not a bug, this a fundamental problem with your proposed technique.

The issue is that file system metadata will be actively in use, and in memory. 
Dealing with the block group descriptors are doable (but would require kernel
changes).  The much bigger problem is going to be with inodes in use by the
mounted data partition.    If you want to boot from a frozen hibernation image,
and reuse it over and over again, this approach is pretty much doomed to
failure, I'm afraid.   All it takes is for one of the system daemons to have
some file opened for writing --- say, such as a log file, and if you try to
reuse the hibernation image, it's a recipe for file system corruption and user
data loss.

If you can change userspace so that you can unmount the data partition, you
could make it work, since in Android the root partition is read-only, and thus
guaranteed not to change.   But that means forcing all of the system daemons
(where by system daemons I am referring to all long-running processes started
at boot before you to suspend your the system  in your fundamentally flawed
quick boot scheme) to close their open files and not have any processes set
with their current working directory in the data partition.   If you could do
that, you could then after the hibernation, remount the data partition, and
then send a signal to all of the system daemons to reopen any open files and
chdir back into /data.

But if you're going to do all of this, you might as well just simply fix the
userspace to have a faster boot sequence.  I'll note that with my Pixel 2 XL,
it has a very fast boot sequence, as does any of my Chromebooks.   So fixing
this problem in userspace is definitely the right way to go --- not by trying
some dirty hack like what you're proposing.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
