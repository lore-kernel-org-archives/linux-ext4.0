From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Sun, 25 Mar 2012 01:20:59 GMT
Message-ID: <201203250120.q2P1KxBN006214@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:35695 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2CYBU7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Mar 2012 21:20:59 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2P1KxHi006215
	for <linux-ext4@vger.kernel.org>; Sun, 25 Mar 2012 01:20:59 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-03-25 01:20:58 ---
>From Peter Anvin, the maintainer of Syslinux:

   Syslinux already includes a private copy of ext2_fs.h, but I
   need to scrub the umode_t inclusion.

This is therefore something that needs to be fixed in Syslinux, and not in the
kernel, so I'm closing this bug.  Peter has been made aware of this issue, so
presumably he will be fixing and releasing a new version of Syslinux shortly.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
