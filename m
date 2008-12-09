From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: Getting direct support for fallocate(2) into glibc
Date: Tue, 09 Dec 2008 01:50:59 -0500
Message-ID: <E1L9wQt-0003dz-DE@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64349 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbYLIGva (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Dec 2008 01:51:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Eric,

Can you or Ric put in a good word with Ulrich (through appropriate Red
Hat channels, if that would be helpful) for this glibc enhancement request:

	http://sources.redhat.com/bugzilla/show_bug.cgi?id=7083

Given that glibc 2.9 was just released, presumably this won't show up
until glibc 2.10, and it'll probably be a *long* time before it this
will show up in real distributions, but it would be good to get this
into functionality into glibc ASAP.

I've been doing an analysis of which files are ending up getting
fragmented on my system, and relatively common case is logfiles (since
they are written via appending).  Another common case is gaim log files,
and of course /var/spool/mail files.  All of these cases could be
addressed by using fallocate() with the FALLOC_FL_KEEP_SIZE flag; and
unfortunately, there is no way to do this currently through a glibc
mediated interface (posix_fallocate() is mandated by the Posix
specification to _not_ pass the FALLOC_FL_KEEP_SIZE flag).

Changing various programs to use fallocate() when the final size of the
file is known (i.e, cp, tar, cpio, rpm, etc.) helps for large files.
And of course, it *definitely* helps for bittorent clients.  So if the
goal is to optimize filesystems aging, this would be a perfect project
to sic an intern or two, or maybe an intro-level Google Summer of Code
students, to sweep through some of the more common programs.  For
programs like cp, tar, et. al, posix_fallocate() will work just fine.
For things like logrotate, we'd either need direct fallocate() support
in glibc, or logrotate would have to call the system call directly,
which would be evil and tricky given that different architectures use
different system call numbers.

(Logrotate could use fallocate to preallocate the new /var/log/syslog to
same size as the previous day's syslog, which has the bonus of
guaranteeing that log messages won't get lost --- and if there's not
enough disk space for the fallocate to succeed, the system administrator
can get notified right away, while there is still free space on the
system.  For paranoid DoD types who want to make sure that the audit
logs are written, this could be quite useful.)

If it's going to take too long to get this into glibc, I guess I could
put an fallocate() interface into libe2p, although that would not be my
first preference.  After all, this sort of thing will be useful for all
filesystems, not just ext4; it should be helpful for xfs and btrfs as
well.

						- Ted
