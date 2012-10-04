From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48301] Kernel panic when try delete really big file (3,3TB)
Date: Thu,  4 Oct 2012 17:49:02 +0000 (UTC)
Message-ID: <20121004174903.026E911FB0B@bugzilla.kernel.org>
References: <bug-48301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279Ab2JDRtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 13:49:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7F51420453
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 17:49:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9EDA920446
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 17:49:03 +0000 (UTC)
In-Reply-To: <bug-48301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48301


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #4 from Theodore Tso <tytso@mit.edu>  2012-10-04 17:49:02 ---
This bug is also fixed in v3.4.10 (although you should probably consider going
to the latest 3.4.x kernel, which is 3.4.11).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
