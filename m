From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Tue, 27 Mar 2012 05:02:37 GMT
Message-ID: <201203270502.q2R52b3I030937@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:44509 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2C0FCh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Mar 2012 01:02:37 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2R52bb3030938
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 05:02:37 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #7 from Theodore Tso <tytso@mit.edu>  2012-03-27 05:02:37 ---
Which EXT2_IOC_* constants are you using?   Aside from the largely specialized
and as far as I know, not ever used, EXT2_IOC_GETRSVSZ and EXT3_IOC_SETRSVSZ,
you can also use (and in fact are encouraged to use), the generic FS_IOC_*
ioctls instead:

#define    EXT2_IOC_GETFLAGS        FS_IOC_GETFLAGS
#define    EXT2_IOC_SETFLAGS        FS_IOC_SETFLAGS
#define    EXT2_IOC_GETVERSION        FS_IOC_GETVERSION
#define    EXT2_IOC_SETVERSION        FS_IOC_SETVERSION

These ioctl started out as ext2 specific, but they are used by multiple file
systems.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
