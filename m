From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Tue, 27 Mar 2012 06:17:59 GMT
Message-ID: <201203270617.q2R6HxI8032563@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:44697 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2C0GR7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Mar 2012 02:17:59 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2R6HxYW032564
	for <linux-ext4@vger.kernel.org>; Tue, 27 Mar 2012 06:17:59 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #11 from Theodore Tso <tytso@mit.edu>  2012-03-27 06:17:59 ---
Yeah, but chmod is POSIX; EXT2_IOC_GETFLAGS is not.  And if you are using the
EXT2_IOC_GETFLAGS variant, then you're saying that you only care about it
working on ext2, and most programs hopefully aspire to more portability than
that.  I really doubt there are _that_ many ext2-specific program out there,
and the flags that can be set by IOC_GETFLAGS really are more esoteric than the
chmod flags.

In any case, Al Viro is carrying the patch in his tree, so ultimately it will
be up to him.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
