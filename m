From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 50021] ext4 discard option not working on journal dissabled
 filesystem
Date: Mon,  5 Nov 2012 17:35:09 +0000 (UTC)
Message-ID: <20121105173509.0D6C811F8EC@bugzilla.kernel.org>
References: <bug-50021-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54575 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab2KERfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2012 12:35:12 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 16723201B6
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 17:35:11 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1F29820167
	for <linux-ext4@vger.kernel.org>; Mon,  5 Nov 2012 17:35:10 +0000 (UTC)
In-Reply-To: <bug-50021-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=50021


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #3 from Theodore Tso <tytso@mit.edu>  2012-11-05 17:35:08 ---
To be fair to the original reporter, this commit only hit the mainline kernel
in 3.7-rc1; given that he's running with a 3.6 kernel, he is running a pretty
up-to-date kernel.

Gregory, as Lukas pointed out, this functionality has been restored via commit
b5e2368baedd.  You should be able to cherry-pick this commit and apply it to
the 3.6 kernel without any difficulty, since it's a fairly straightforward
patch.

Regards,

-- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
