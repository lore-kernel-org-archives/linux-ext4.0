From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] NULL pointer dereference in ext4_ext_remove_space on
 3.5.1
Date: Mon, 17 Sep 2012 12:07:17 +0000 (UTC)
Message-ID: <20120917120717.8ED1F11FB49@bugzilla.kernel.org>
References: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51435 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab2IQMHV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 08:07:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 10F872027D
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 12:07:20 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5F65320250
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 12:07:18 +0000 (UTC)
In-Reply-To: <bug-47611-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2012-09-17 12:07:17 ---
Fixed by commit: 89a4e48f8479f: "ext4: fix kernel BUG on large-scale rm -rf
commands", which appeared in Linus's tree as of 3.6-rc3, and which was
backported to v3.5.3.

(Dmitry, looking at your patch, I'm guessing you haven't tried rebasing your
patch series to 3.6-rc3 or later?   If you haven't, that would be much
appreciated.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
