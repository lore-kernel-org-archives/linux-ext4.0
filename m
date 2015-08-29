From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Sat, 29 Aug 2015 03:25:15 +0000
Message-ID: <bug-103111-13602-0pGHXtrvYz@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52272 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbbH2DZU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Aug 2015 23:25:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3973720A4B
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 03:25:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 765FF20A50
	for <linux-ext4@vger.kernel.org>; Sat, 29 Aug 2015 03:25:16 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #14 from Theodore Tso <tytso@mit.edu> ---
Rakesh, if you are aware of truly broken programs that rename first and then
write to the file (which means that they will lose data if they crash after the
rename), let me know.  The hueristics were designed to catch the most common
cases of application brain-damage, to it:

1)  write foo.new
2)  fail to use fsync(2) as they should
3)  close the file descriptor for foo.new
4)  rename foo.new to foo

The fact that we also catch the case of

1)  truncate a file containing data down to zero
2)  write a new version of the file, and hope you don't crash right after 1

Was because, if I recall correctly, both GNOME and KDE had something like this
in their library functions and a lot of programs were calling it.   ***Sigh***

I believe their excuse was that it was too hard to copy the ACL's and xattr's
from foo to foo.new, and by using a truncate, they wouldn't have to do all of
that hard work to read the acl and xattr's from the old file, and set them on
foo.new before doing the rename.

One especially brilliant application was rewriting the config file after each
time the window was moved a pixel or two, so that the window location could be
saved.   So if you dragged the window around, the file would get written dozens
if not hundreds of times.

Just in case you ever wondered why many file system developers don't trust
application / desktop programmers....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
