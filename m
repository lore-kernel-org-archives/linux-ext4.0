From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15910] zero-length files and performance degradation
Date: Mon, 10 May 2010 03:49:35 GMT
Message-ID: <201005100349.o4A3nZqB013514@demeter.kernel.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56146 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0EJDtg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 May 2010 23:49:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4A3nasl013515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 10 May 2010 03:49:36 GMT
In-Reply-To: <bug-15910-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15910





--- Comment #5 from Theodore Tso <tytso@mit.edu>  2010-05-10 03:49:25 ---
> The problem is, dpkg needs to guarantee the system is always usable,
> and when a crash occurs, say when it's unpacking libc, it's not
> acceptable for dpkg not to fsync() before rename() as it might end
> up with an empty libc.so file, even if it might have marked the
> package as correctly unpacked (wrongly but unknowingly as there's no
> guarantees), which is not true until the changes have been fully
> committed to the file system.

Why not unpack all of the files as "foo.XXXXXX" (where XXXXXX is a
mkstemp filename template) do a sync call (which in Linux is
synchronous and won't return until all the files have been written),
and only then, rename the files?  That's going to be the most fastest
and most efficient way to guarantee safety under Linux; the downside
is that you need to have enough free space to store the old and the
new files in the package simultaneously.  But this also is a win,
because it means you don't actually start overwriting files in a
package until you know that the package installation is most likely
going to succeed.  (Well, it could fail in the postinstall script, but
at least you don't have to worry about disk full errors.)

                                             - Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
