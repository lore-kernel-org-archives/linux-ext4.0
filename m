From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Sun, 03 Jul 2016 18:38:47 +0000
Message-ID: <bug-121371-13602-nqs500Wxgy@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbcGCSiu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jul 2016 14:38:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 703902028D
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 18:38:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D401420259
	for <linux-ext4@vger.kernel.org>; Sun,  3 Jul 2016 18:38:47 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

Darrick J. Wong <djwong+kernel@djwong.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |djwong+kernel@djwong.org

--- Comment #3 from Darrick J. Wong <djwong+kernel@djwong.org> ---
The undeletable directory also has the inline_data flag set, even though the
filesystem doesn't ==> possible memory bitflip?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
