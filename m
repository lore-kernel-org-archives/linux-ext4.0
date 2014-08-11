From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Mon, 11 Aug 2014 05:06:13 +0000
Message-ID: <bug-61601-13602-FS6UDfIPDL@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaHKFGR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 01:06:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 03561201C8
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 05:06:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6573120173
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 05:06:13 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #10 from Theodore Tso <tytso@mit.edu> ---
Here's what's going on.   There are some mount flags that are parsed by the
userspace mount program, and translated to an integer field "mountflags" in the
mount(2) system call.   See the man page for mount(2) for more details; see the
flags MS_NOATIME, MS_NOEXEC, MS_NOSUID, etc.  They are described in the
mount(8) system call in the section "FILESYSTEM INDEPENDENT MOUNT OPTIONS".

If you are using an initrd, the rootflags boot line command is handled by the
userspace mount program; the initrd is responsible for mounting the root file
system, and it does so using mount(8).

However, if you are not using an initrd, then the mount flags are handled by
/usr/src/linux/init/do_mounts.c, and the kernel code simply doesn't handle
converting "noatime" into MS_NOATIME and then or'ing it into root_mountflags.

The simplest workaround is to add in your init scripts the command:

mount -o remount,noatime /

you could combine this with the init script command which remounts the root
file system read-only, i.e.:   mount -o remount,rw,noatime /

P.S.  Ignore Nick's comment in #9.  He's guessing, and he doesn't know what
he's doing.  He's been banned from LKML, but unfortunately he hasn't been
banned from the kernel bugzilla yet.  It's one thing when he's wasting
maintainers' time, but when he's confusing and adding negative value to users
who are asking for help, it's definitely not ok.   We'll have to remedy
that....

See https://plus.google.com/+TheodoreTso/posts/ELVf6FmuY2N for more details.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
