From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 10:51:49 GMT
Message-ID: <200910171051.n9HApnhw015305@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46295 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZJQKvp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 06:51:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9HApnck015306
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 10:51:49 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #78 from Theodore Tso <tytso@mit.edu>  2009-10-17 10:51:41 ---
Alexey,

There is a very big difference between _files_ being corrupted and the
_file_ _system_ being corrupted.  Your test, as I understand it, is a
"make modules_install" from a kernel source tree, followed immediately
by a forced crash of the system, correct?  Are you doing an "rm -rf
/lib/modules/2.6.32-XXXX" first, or are you just doing a "make
modules_install" and overwriting files.

In any case, if you don't do a forced sync of the filesystem, some of
the recently written files will be corrupted.  (Specifically, they may
be only partially written, or truncated to zero-length.)  This is
normal and to be expected.  If you want to make sure files are written
to stable storage, you *must* use sync or fsync(3).

This is true for pretty much any file system, by the way.  If you have
a script that looks something like this

#!/bin/sh
rm -rf /lib/modules/`uname -r`
make modules_install
echo c > /proc/sysrq-trigger

you _will_ end up with some files being missing, or not fully written
out.  Try it with ext3, xfs, btrfs, reseirfs.  All Unix filesystems
have some amount of asynchronous writes, because otherwise performance
would suck donkey gonads.  You can try to mount with -o sync, just to
see how horrible things would be.

So what do you do if you have a "precious" file --- a file where you
want to update its contents, but you want to make absolutely sure
either the old file or the new file's contents will still be present?
Well, you have to use fsync().  Well-written text editors and things
like mail transfer angents tend to get this right.  Here's one right
way of doing it:

1)  fd = open("foobar.new", O_CREAT|O_TRUNC, mode_of_foobar);
2)  /* copy acl's, extended attributes from foobar to foobar.new */
3)  write(fd, buf, bufsize); /* Write the new contents of foobar */
4)  fsync(fd);
5)  close(fd);
6)  rename("foobar.new", "foobar");

The basic idea is you write the new file, then you use fsync() to
guarantee that the contents have been written to disk, and then
finally you rename the old file on top of the old one.

As it turns out, for a long time Linux systems were drop dead
reliable.  Unfortunately, recently with the advent of ACPI
suspend/resume, which assumed that BIOS authors were competent and
would test on OS's other than windows, and proprietry video drivers
that tend to be super unreliable, Linux systems have started crashing
more often.  Worse yet, application writers are started getting
sloppy, and would write code sequences like this when they want to
update files:

1)  fd = open("foobar", O_CREAT|O_TRUNCATE, default_mode);
2)  write(fd, buf, bufsize); /* write the new contents of foobar */
3)  close(fd);

Or this:

1)  fd = open("foobar.new", O_CREAT|O_TRUNC, mode_of_foobar);
2)  write(fd, buf, bufsize); /* Write the new contents of foobar */
3)  close(fd);
4)  rename("foobar.new", "foobar");

I call the first "update-via-truncate" and the second
"update-via-replace".  Because with delayed allocation, files have a
tendency to become zero-length if you update them without using
fsync() and than an errant ACPI bios or buggy video driver takes your
system down --- and because KDE was updating many more dot files than
necessary, and firefox was writing half a megabyte of disk files for
every single web click, people really started to notice problems.

As a result, we have hueristics that detect update-via-rename and
update-via-truncate, and if we detect this write pattern, we force a
background writeback of that file.  It's not a synchronous writeback,
since that would destroy performance, but a very small amount of time
after a close(2)'ing a file descript that was opened with O_TRUNCATE
or which had been explicitly truncated down to zero using ftruncate(2)
-- i.e., update-via-truncate --- , or after a rename(2) which causes
an inode to be unlinked --- i.e., uodate-via-unlink --- the contents
of that file will be written to disk.  This is what auto_da_alloc=0
inhibits.

So why is it that you apparently had no data loss when you used
auto_da_alloc=0?  I'm guessing because the file system activity entire
script fit within a single jbd2 transaction, and the transaction never
committed before the script forced a system crash.  (Normally a
transaction will contain five seconds of filesystem activity, unless
(a) a program calls fsync(), or (b) there's been enough file system
activity that a significant chunk of the journal space has been
confused.

One of the changes between 2.6.31 and 2.6.32-rc1 was a bugfix that
fixed a problem in 2.6.31 where update-via-truncate wasn't getting
detected.  This got fixed in 2.6.32-rc1, and that does change when
data gets forced out to disk.

But in any case, if it's just a matter of the file contents not
getting written to disk, that's expected if you don't use fsync() and
you crash immediately afterwards.  As I said earlier, all file systems
will tend to lose data if you crash without first using fsync().

The bug which I'm interested in replicating is one where the actual
_file_ _system_ is getting corrupted.  But if it's just a matter of
not using sync() or fsync() before a crash, that's not a bug.

                                   - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
