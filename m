From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55651] Non-atomic short write problem with O_APPEND
Date: Wed, 27 Mar 2013 18:57:25 +0000 (UTC)
Message-ID: <20130327185725.313AA11FB3C@bugzilla.kernel.org>
References: <bug-55651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45989 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3C0S53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 14:57:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 254CC20419
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:57:28 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3114B20431
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 18:57:25 +0000 (UTC)
In-Reply-To: <bug-55651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55651


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED
                 CC|                            |tytso@mit.edu
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2013-03-27 18:57:24 ---
The commit in question (a50527b1) was authored by Jan Kara so I've changed the
assignee of this bug to him.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
