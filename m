From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Tue, 18 Jul 2017 21:37:32 +0000
Message-ID: <bug-196405-13602-x8n20HebSo@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:37144 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752464AbdGRVhf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 18 Jul 2017 17:37:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A7EEA285F7
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 21:37:34 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #3 from Theodore Tso (tytso@mit.edu) ---
> Is it necessary for it to "break" (quotes because 1 seems to be a kind-of
> wildcard) at such a low and weird value?

The reason for choosing 1 is because there were other file systems
where they don't have a '..' where the link count of the directory is
1.  In fact, I just checked; I can't find anything in POSIX or the
Single Unix Specification which guarantees that '.' and '..' are hard
links.  It is that way historically, but there are file systems such
as VFAT where this is not true.

That's important because there are programs which, if they see a link
count of 42, if they are doing a directory tree walk, and they see 42
directories, they will assume that there are no more subdirectories at
that level.  I suppose we could have used a link count of 0xFFFFFFFF
as the magic "lots" value, but that could potentially trigger overflow
bugs in programs.  And given that most of these programs already
understand that 1 is "lots" so they can do the right thing when you
run "find" on a mounted thumb drive using VFAT.

> This behavior doesn't occur with ext4 ram disks. Run the same command,
> possibly
> with an even higher number, but within an ext4 ram disk, created via
> 
>     $ sudo mount -t ramfs -o size=4G ext4 <path>

That's not a ext4 ram disk.  That's a tmpfs partition (ramfs is an
alias for tmpfs).  "ext4" in the above invocation can be anything, and
it has no meaning.  Just as "mount -t proc proc /proc" is equivalent
to "mount -t proc xyzzy /proc", the above can also be:

        sudo mount -t ramfs -o size=4G xyzzy <path>

And it will be the same as "sudo mount -t ramfs -o size=4G ext4 <path>".

                           - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
