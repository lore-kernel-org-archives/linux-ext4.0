From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Sun, 23 Jul 2017 16:23:55 +0000
Message-ID: <bug-196405-13602-N8MI0y0PDM@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:56960 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751367AbdGWQYC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 12:24:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 37B3D27F94
        for <linux-ext4@vger.kernel.org>; Sun, 23 Jul 2017 16:24:02 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #23 from Theodore Tso (tytso@mit.edu) ---
For the record, the documentation is not wrong; the maximum link count is 65000
--- for files.

# touch 1
# for i in $(seq 2 65000) ; do ln 1 $i ; done
# ls -l 1
-rw-r--r-- 65000 root root 0 Jul 23 12:11 1
# ln 1 65001
ln: failed to create hard link to '1': Too many links

The fact dir_nlink happens to let st_nlink go from 64999 to 1 is (1) not an
overflow, and (2) isn't actually contradicting any documentation, insofar as
all we say is that dir_nlink no longer limits the number of subdirectories due
to EXT4_MAX_LINK count.   The documentation is only subtly wrong when it says:

       dir_nlink
              This ext4 feature allows more than 65000 subdirectories per
directory.

That is actually a true statement, it *does* allow more than 65000
subdirectories per directory.  What is not quite true is that without that
feature, we are limited to 65000 subdirectories.   Today, because with ext4 the
feature gets silently enabled, and with ext2, the failure happens after the
64998th subdirectory (because the directory entry for the parent directory plus
the '.' link counts as an st_nlink).

I'll point out that POSIX/SUSv3 doesn't even guarantee *any* value for st_nlink
for directories, since hard links to directories are not allowed, and what
st_nlink means in the absence of hard links, or directories in general, are not
specified.  So just as GCC developers delight in torturing kernel developers by
allowing anything random (including launching nethack) for anything which is
not concretely specified by the C standard, technically speaking a random Linux
file system could let st_nlink random around randomly, or increase according to
a fibbonacci or geometric series, etc.   More seriously, for a
network/clustered file system, if other subdirectories are being created while
the file walk is taking place (or even in the case of a local file system),
relying on st_nlink for an optimization is going to be dangerous.  Using d_type
is going to be ***much*** safer.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
