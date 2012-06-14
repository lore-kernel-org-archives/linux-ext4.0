From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] Corruption on a small loopback ext4 file system with
 Linux 3.4
Date: Thu, 14 Jun 2012 21:48:42 +0000 (UTC)
Message-ID: <20120614214842.381D411FE1F@bugzilla.kernel.org>
References: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44247 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab2FNVsr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2012 17:48:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D107320488
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2012 21:48:45 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1C44F204AF
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2012 21:48:43 +0000 (UTC)
In-Reply-To: <bug-43354-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #5 from Jan Kara <jack@suse.cz>  2012-06-14 21:48:41 ---
Hmm, I'm not able to reproduce with 3.5-rc1. Can you?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
