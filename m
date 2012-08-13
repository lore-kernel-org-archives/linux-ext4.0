From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16583] ext4: delayed block allocation failed and application
 not respond any more
Date: Mon, 13 Aug 2012 19:34:25 +0000 (UTC)
Message-ID: <20120813193425.7199511FB49@bugzilla.kernel.org>
References: <bug-16583-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38664 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2HMTe2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Aug 2012 15:34:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 90D6C20227
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2012 19:34:27 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 05B2620214
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2012 19:34:26 +0000 (UTC)
In-Reply-To: <bug-16583-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16583


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-08-13 19:34:25 ---
Also, in the original bug report, (which was against an usptream kernel,
2.6.35) note:

EXT4-fs (dm-6): warning: mounting fs with errors, running e2fsck is recommended

If this means the file system was mounted with inconsistencies noted in the
past.

And sure enough...

EXT4-fs error (device dm-6): ext4_ext_search_left: inode #3510: (comm
flush-254:6) ix (42117) != EXT_FIRST_INDEX (0) (depth 1)!

... is a file system inconsistency. 

The second reporter, Loredan, was using a Red Hat modified 2.6.32 kernel, and
the RHEL 2.6.32 kernel is significantly different from upstream.  I will note
that it wasn't clear whether the file system was being grown or shrunk, but in
the more typical case of growing the file system, in general you should resize
the LVM first, and *then* run resize2fs to resize the filesystem to use the
newly enlarged LV.

Regards,

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
