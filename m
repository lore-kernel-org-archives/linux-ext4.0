From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 22:33:15 GMT
Message-ID: <201005102233.o4AMXFav021768@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43404 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab0EJWdR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 18:33:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4AMXGmU021769
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 May 2010 22:33:16 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910





--- Comment #9 from Theodore Tso <tytso@mit.edu>  2010-05-10 22:33:09 ---
I'll grant that using sync(2) is non-portable, but relying on _not_ needing an
fsync(2) at all was also just as non-portable, if not worse (it only really
worked on ext3, and no other file system, and of course only on Linux).

Trying to make (fsync ,rename)**N --- that is, alternating fsync and rename
calls --- fast is always going to be difficult for nearly all file systems. 
The fundamental problem is that file systems are optimized for throughput when
you're _not_ calling fsync all the time, that's a very different sort of thing
than what databases need to do --- and databases generally solve the problem by
having _two_ logs, a redo and an undo log.  I don't know of any filesystem
which has that kind of complexity, and so pretty much any filesystem where you
have a series if fsync() and rename() calls interleaves is going to run you
into pain.   Some filesystems will be better at it than others, but it's always
going to be faster to write all the files, do a single sync, and then do all of
the renames.   Yeah, that's non-portable; the problem is that the only
synchronization primitive which POSIX gives us is fsync(), and so we just don't
have a lot of options in terms of what we communicate between userspace and the
kernel.

One of the things I wonder about is why are users' systems cashing so often
such that this is a problem?  I can't remember the last time I've had a system
crash while I've been doing an "apt-get dist-upgrade" or "apt-get upgrade".  Is
this a common problem or an uncommon problem?    And if it's not that common
(and I hope it is, but maybe Ubuntu is shipping too many unstable crappy binary
device drivers), maybe the right answer is to have rescue CD's or rescue
partitions which will automatically repair a damaged libc package if the
systems just happened to crash while upgrading glibc.   Again, let's optimize
for the common case, and I hope we've haven't entered the windows world where
blue screens of death are so common that this is the case we have to optimize
for....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
