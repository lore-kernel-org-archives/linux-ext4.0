From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Sun, 9 May 2010 18:19:12 GMT
Message-ID: <201005091819.o49IJCQG017276@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60658 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0EISTN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 May 2010 14:19:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o49IJCHJ017277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 9 May 2010 18:19:12 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910


Guillem Jover <guillem@hadrons.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |guillem@hadrons.org




--- Comment #4 from Guillem Jover <guillem@hadrons.org>  2010-05-09 18:19:07 ---
Hi!

(In reply to comment #1)
> Why can't you #1, just fsync after writing the control file, if that's the
> primary problem?
> 
> Or #2, make the dpkg recover more gracefully if it finds that the control file
> has been truncated down to zero?

dpkg is now fsync()ing after all internal db changes, control file extractions,
*and* to be installed files extracted from the deb package. It's also
fsync()ing directories for at least all db directory changes.

As background info, dpkg used to fsync() all db files except for the newly
extracted control files.

> The reality is that all of the newer file systems are going to have this
> property.  XFS has always behaved this way.  Btrfs will as well.  We are _all_
> using the same hueristic to force sync a file which is replaced via a rename()
> system call, but that's really considered a workaround buggy application
> programs that don't call fsync(), because there are more stupid application
> programmers than there are of us file system developers.

I don't have any problem with that, and I personally consider previous dpkg
behaviour buggy. And as you say it's bound to cause problems on other file
systems eventually.

> As far as the rest of the files are concerned, what I would suggest doing is
> set a sentinel value which is used to indicate that package is being installed,
> and if the system crashes, either in the init scripts or the next time dpkg
> runs, it should reinstall that package.   That way you're not fsync()'ing every
> single file in the package, and you're also not optimizing for the exception
> condition.   You just have appropriate application-level retries in case of a
> crash.

dpkg already marks packages which failed to unpack as such, and that they need
to be reinstalled, it can also recover from such situations by rolling back to
the previous files, which it keeps as backups until it has finished the current
package operation.

The problem is, dpkg needs to guarantee the system is always usable, and when a
crash occurs, say when it's unpacking libc, it's not acceptable for dpkg not to
fsync() before rename() as it might end up with an empty libc.so file, even if
it might have marked the package as correctly unpacked (wrongly but unknowingly
as there's no guarantees), which is not true until the changes have been fully
committed to the file system.

If any file of the many packages which are required for a system to boot
properly or for dpkg itself to operate correctly ends up with zero-length then
neither the user nor the system will be able to recover from this situation.
Worse is that this might require recovering from a different media, for
example, which end-users should not be required to do, or they might just not
know how to.

I guess in this regard dpkg is special, and it cannot be compared to something
like firefox fsync()ing too much, if dpkg fails to operate properly your entire
system might get hosed.

> So Debian and Ubuntu have a choice.  You can just stick with the ext3, and not
> upgrade, but this is one place where you can't blackmail file system developers
> by saying, "if you don't do this, I'll go use some other file system" ---
> because we are *all* doing delayed allocation.   It's allowed by POSIX, and
> it's the only way to get much better file system performance --- and there are
> intelligent ways you can design your applications so the right thing happens on
> a power failure.   Programmers used to be familiar with these in the days
> before ext3, because that's how the world has always worked in Unix.  
> 
> Ext3 has lousy performance precisely because it guaranteed more semantics that
> what was promised by POSIX, and unfortunately, people have gotten flabby
> (think: the humans in the movie Wall-E) and lazy about how to write programs
> that write to the file system defensively.   So if people are upset about the
> performance of ext3, great, upgrade to newer file systems.   But then you will
> need to be careful about how you code applications like dpkg.

The main problem is that doing the right thing (fsync() + rename()), does not
really penalize ext3 users, but it does on ext4 which is the one which really
needs it. So we end up with lots of users (mostly from Ubuntu though, as the
one who has already switched to ext4 as default) complaining the slow down is
unacceptable, and I don't see much options besides adding a --force-unsafe-io
or similar, which those users would add in the dpkg.cfg file with the
acknowledgment thay might lose data in case of an abrupt halt.

Something in between we have talked about is doing fsync() on extracted files
only for a subset of the packages, say only for priority important or higher,
which besides being the wrong solution does not cover for example packages as
important as the kernel or boot loaders. Obviously better than no fsync() at
all but still not right, this could be added as --force-unsafe-io and the
previous as --force-unsafer-io though, but still.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
