From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Sat, 24 Mar 2012 14:04:35 GMT
Message-ID: <201203241404.q2OE4ZuN024107@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:33491 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2CXOEf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 10:04:35 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2OE4ZJe024108
	for <linux-ext4@vger.kernel.org>; Sat, 24 Mar 2012 14:04:35 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-03-24 14:04:34 ---
Why do you need ext2_fs.h?   We're planning on removing ext2_fs.h as an
exported header file very shortly (perhaps as soon as v3.4; it's already in Al
Viro's VFS git tree).

Ext 2/3/4 userspace programs ***really*** should be using libext2fs, and if for
some reason they don't want to do that, they can use the ext2_fs.h header file
that is shipped with e2fsprogs and libext2fs.

Programs written as much as 8 years ago and which used libext2fs generally were
able to support ext4 file systems have generally been able to support ext4;
that's one of the major reasons why I strongly suggest the use of that library,
instead of trying to use kernel header files to roll your own thing....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
