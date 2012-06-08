From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] Corruption on a small loopback ext4 file system with
 Linux 3.4
Date: Fri,  8 Jun 2012 04:18:27 +0000 (UTC)
Message-ID: <20120608041827.617CF11FC41@bugzilla.kernel.org>
References: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab2FHESd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 00:18:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A8D7A203C1
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 04:18:32 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 66D6E203C9
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 04:18:27 +0000 (UTC)
In-Reply-To: <bug-43354-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354





--- Comment #1 from Alec Moskvin <alecm@gmx.com>  2012-06-08 04:18:27 ---
Created an attachment (id=73536)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73536)
tree.ext4.xz - resulting fs image

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
