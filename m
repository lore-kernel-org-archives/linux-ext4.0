From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Wed, 19 Jul 2017 14:49:33 +0000
Message-ID: <bug-196405-13602-Qcpnqh84Ai@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54130 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754772AbdGSOtf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 10:49:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 08F4E269DA
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 14:49:35 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #11 from Theodore Tso (tytso@mit.edu) ---
On Wed, Jul 19, 2017 at 08:02:25AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=196405
> 
> --- Comment #10 from Paul Eggert (eggert@cs.ucla.edu) ---
> (In reply to Andreas Dilger from comment #9)
> > while the "ftsfind.c"
> > code does not check nlinks directly (presumably that is done in fts), the
> > "oldfind.c::process_dir()" code has a check if st_nlink < 2
> 
> Sure, but (as its name suggest) oldfind.c is obsolete and is no longer used.
> The mainline 'find' code does not have a special case for st_nlink < 2, and
> works only by accident.

Well, ext4's dir_nlinks feature has been around for the last *decade*:

commit f8628a14a27eb4512a1ede43de1d9db4d9f92bc3
Author: Andreas Dilger <adilger@clusterfs.com>
Date:   Wed Jul 18 08:38:01 2007 -0400

    ext4: Remove 65000 subdirectory limit

    This patch adds support to ext4 for allowing more than 65000
    subdirectories. Currently the maximum number of subdirectories is capped
    at 32000.

    If we exceed 65000 subdirectories in an htree directory it sets the
    inode link count to 1 and no longer counts subdirectories.  The
    directory link count is not actually used when determining if a
    directory is empty, as that only counts subdirectories and not regular
    files that might be in there.....

.... and it is based on behavior that has been around for some legacy
file systems for much longer than that.  If the mainline "find" code
has regressed, I suggest you file a bug with the findutils/glibc
folks, as that would appear to be their bug, not ext4's.  As I've
said, I've looked at the Posix and SUS specs, and '.' and '..' are
specified to be "special filenames" that have to be honored when
resolving pathnames.  There is no requirement that they have to be
implemented as hard links, and so therefore there is no guarantee that
st_nlink can be used as a hint for the number of subdirectories.  And
that's good, because there are file systems that don't have hard links
at all (NTFS, for example; and there have been versions of Windows
that have gotten Posix certification).

                                         - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
