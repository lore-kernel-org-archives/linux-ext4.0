From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 17:23:36 GMT
Message-ID: <201005101723.o4AHNa3r031062@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53648 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0EJRXh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 13:23:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4AHNbse031063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 May 2010 17:23:37 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910





--- Comment #8 from Guillem Jover <guillem@hadrons.org>  2010-05-10 17:23:31 ---
(In reply to comment #5)
> Why not unpack all of the files as "foo.XXXXXX" (where XXXXXX is a
> mkstemp filename template) do a sync call (which in Linux is
> synchronous and won't return until all the files have been written),
> and only then, rename the files? That's going to be the most fastest
> and most efficient way to guarantee safety under Linux; the downside
> is that you need to have enough free space to store the old and the
> new files in the package simultaneously. But this also is a win,
> because it means you don't actually start overwriting files in a
> package until you know that the package installation is most likely
> going to succeed.  (Well, it could fail in the postinstall script, but
> at least you don't have to worry about disk full errors.)

Ah, forgot to mention that we also discussed about using sync(), but
the problem as you say is that using sync() is not portable, so we need
the deferred fsync() and rename() code anyway for unpacked files on
non-Linux systems. Another possible issue, is that if there's been lots
of I/O in parallel or just before running dpkg the sync() might take much
longer than expected, but depending on the implementation fsync() might
show similar slowdowns anyway (not, though if it was on a different
"disk" and file system).

Regarding the downsides and wins you mention they already apply to the
current implementation. As I mentioned before dpkg has always supported
rolling back, by making a hardlinked backup of the old file as .dpkg-tmp,
extracting the new file as .dpkg-new and then doing an atomic rename() over
the current file, and in case of error (from dpkg itself or the appropriate
maintainer script) restoring all the old file backups for the package
(either in the current run or in a subsequent dpkg run). And only once
the unpack stage has been successful it removes the backups in one pass.
So the need for rollback already makes dpkg take (approx.) twice the space
per package, and thus there's no unsafe overwrites that cannot be reverted
(except for the zero-length ones).

I've added the conditional code now for Linux to do the sync() and then
rename() all files in one pass, and it's just few lines of code (due to
the deferred fsync() changes which are now in place), I'll request some
testing from ext4 users, and if it improves something and does not make
the matters worse on ext3 and other file systems, then I guess we might
use that on Linux. It still looks like a workaround to me.

As a side remark, I don't think it's fair though, that you complain about
application developers not doing the right thing, when at the same time,
you expect them not to use the proper portable tool for such job. And that
you seem to not see a problem that using it implies a performance penalty
on a file system that really needs it. That there's lots of users willing
to sacrifice safety for performance, tells me the penalty is significant
enough. Isn't there anything that could be improved to make the correct
fsync()+rename() case a bit faster? In this particular case those are
already batched after all writes have been performed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
