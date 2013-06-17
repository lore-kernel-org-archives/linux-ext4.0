From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59801] kernel BUG at /kernel/fs/ext4/extents.c:1996!
Date: Mon, 17 Jun 2013 12:35:29 +0000 (UTC)
Message-ID: <20130617123529.DEE8911FB51@bugzilla.kernel.org>
References: <bug-59801-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60923 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab3FQMfh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 08:35:37 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1D89620300
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 12:35:32 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E4D66202EA
	for <linux-ext4@vger.kernel.org>; Mon, 17 Jun 2013 12:35:29 +0000 (UTC)
In-Reply-To: <bug-59801-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=59801


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2013-06-17 12:35:29 ---
Especially with ARM, where in general there is no standardization on C library
shared library bindings, etc., you really need to build user packages for
yourself.    There are more modern (1.42.5) packages for e2fsprogs compiled for
ARM from Debian, but there's no guarantee that it will work on whatever system
you are using.

Please note that support of old kernels, especially kernels as old as 3.0, is
on "best effort" basis.  People who have to use old kernels on a commercial
basis should get help from a commercial support organization (or build up ext4
expertise within their own organization, but the former is generally more
economically effective).   There are a huge number of bug fixes since 3.0, and
while there are a few people will try to backport fixes to the 3.0 kernel, the
testing to make sure those fixes do not introduce new bugs, and the effort to
backport patches if they do not apply cleanly to older kernels, is very much on
a best effort basis.

If the problem is really obvious, as in this case, where I can find the problem
after looking for a few seconds, the open source community can try to give you
support.  But if it requires more work than that, we can't help you --- we just
wouldn't have the time to improve ext4 for the upstream kernel if we were to
supply free support for ancient kernels.  (Not to mention that it would not be
fair for those engineers whose salaries come from getting paid to support
ancient kernels.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
