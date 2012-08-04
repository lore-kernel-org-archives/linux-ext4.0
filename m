From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16380] ext2/ext4 filesystem "hangs" for a few seconds when
 trying to write a lot of data to a freshly RW mounted FS
Date: Sat,  4 Aug 2012 18:13:20 +0000 (UTC)
Message-ID: <20120804181320.D191711FC62@bugzilla.kernel.org>
References: <bug-16380-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45577 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2HDSNY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Aug 2012 14:13:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 730F920223
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 18:13:23 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C435820209
	for <linux-ext4@vger.kernel.org>; Sat,  4 Aug 2012 18:13:21 +0000 (UTC)
In-Reply-To: <bug-16380-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16380





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2012-08-04 18:13:20 ---
I wasn't able to duplicate this with an underlying ext4 file system, with the
loop file system being ext2, using a 3.5 kernel on a system with 16G.

I tried both using a variety of small and medium sized files, as well as one
very large file, and I didn't see any unexplained stuttering in write
bandwidth.   (There were times when cp -r was clearly writing to the in-memory
page cache, and the writeback hadn't begone yet.   There were also times when
we couldn't do any more writing, because we were busy reading from the source
drive.  But it all looked pretty normal to me.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
