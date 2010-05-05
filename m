From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Wed, 5 May 2010 18:54:48 GMT
Message-ID: <201005051854.o45IsmJk027144@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41470 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0EESzG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:55:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o45IsnCL027148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 May 2010 18:54:49 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2010-05-05 18:54:23 ---
Why can't you #1, just fsync after writing the control file, if that's the
primary problem?

Or #2, make the dpkg recover more gracefully if it finds that the control file
has been truncated down to zero?

The reality is that all of the newer file systems are going to have this
property.  XFS has always behaved this way.  Btrfs will as well.  We are _all_
using the same hueristic to force sync a file which is replaced via a rename()
system call, but that's really considered a workaround buggy application
programs that don't call fsync(), because there are more stupid application
programmers than there are of us file system developers.

As far as the rest of the files are concerned, what I would suggest doing is
set a sentinel value which is used to indicate that package is being installed,
and if the system crashes, either in the init scripts or the next time dpkg
runs, it should reinstall that package.   That way you're not fsync()'ing every
single file in the package, and you're also not optimizing for the exception
condition.   You just have appropriate application-level retries in case of a
crash.

So Debian and Ubuntu have a choice.  You can just stick with the ext3, and not
upgrade, but this is one place where you can't blackmail file system developers
by saying, "if you don't do this, I'll go use some other file system" ---
because we are *all* doing delayed allocation.   It's allowed by POSIX, and
it's the only way to get much better file system performance --- and there are
intelligent ways you can design your applications so the right thing happens on
a power failure.   Programmers used to be familiar with these in the days
before ext3, because that's how the world has always worked in Unix.  

Ext3 has lousy performance precisely because it guaranteed more semantics that
what was promised by POSIX, and unfortunately, people have gotten flabby
(think: the humans in the movie Wall-E) and lazy about how to write programs
that write to the file system defensively.   So if people are upset about the
performance of ext3, great, upgrade to newer file systems.   But then you will
need to be careful about how you code applications like dpkg.

In retrospect, I really wish we hadn't given programmers the data=ordered
guarantees in ext3, because they both trashed ext3's performance and caused
application programmers to get the wrong idea about how the world worked. 
Unfortunately, the damange has been done....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
