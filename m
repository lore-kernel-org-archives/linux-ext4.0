From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Wed, 19 Jul 2017 19:59:41 +0000
Message-ID: <bug-196405-13602-pJlgM1cC6E@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56922 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751995AbdGST7p (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 15:59:45 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C161E23B32
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 19:59:44 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #13 from Paul Eggert (eggert@cs.ucla.edu) ---

(In reply to Theodore Tso from comment #11)
> If the mainline "find" code has regressed

It hasn't regressed; it still works as long as the directory has fewer than
2**32 subdirectories (assuming x86), and as long as the compiler generates code
compatible with -fwrapv semantics, and this is good enough in practice. It's
still a matter of luck that findutils works, though. And glibc itself does not
work, as shown in the fts-test.c program attached to this bug report.

> I've looked at the Posix and SUS specs, and '.' and '..' are
> specified to be "special filenames" that have to be honored when
> resolving pathnames.  There is no requirement that they have to be
> implemented as hard links

Yes, of course. However, 'find', etc. have optimizations for GNU/Linux, e.g.,
code like this:

#if defined __linux__ && HAVE_FSTATFS && HAVE_STRUCT_STATFS_F_TYPE
[special code that runs only on GNU/Linux platforms, and that significantly
improves performance on those platforms]
#else
[generic code that runs on any POSIX platform, albeit more slowly]
#endif

and the GNU/Linux-specific code is broken on ext4 because the ext4 st_nlink is
not a link count. Obviously we could fix the problem by using the generic code
on GNU/Linux too; but this would hurt GNU/Linux performance significantly in
some cases.

> there are file systems that don't have hard links
> at all (NTFS, for example; and there have been versions of Windows
> that have gotten Posix certification).

The code in question already deals with both these issues, by avoiding
st_nlink-based optimizations on NTFS and other filesystems where st_nlink is
unreliable. The ext4 problem, though, is new to me, and evidently to everyone
else who's maintained the glibc etc. code, and this is why glibc is currently
broken on ext4 directories with 64998 or more subdirectories.

How about this idea for moving forward?

1. Clearly document that setting dir_nlink can break user-mode code, such as
glibc's fts functions.

2. Fix the four ext4 bugs that I mentioned in Comment 12.

3. For GNU utilities, override glibc's fts functions to work around the bugs
when they operate on ext4 filesystems.

4. File a glibc bug report for the bug exhibited in fts-test.c.

5. Disable dir_nlink in new ext4 filesystems, unless it is specifically
requested.

The combination of these changes should fix the problem in the long run.

I can volunteer to do (3) and (4). Can you do (1), (2), and (5)?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
