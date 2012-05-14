From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32122] Kernel BUG on accessing intentionally corrupted
 filesystem
Date: Mon, 14 May 2012 14:35:09 +0000 (UTC)
Message-ID: <20120514143509.4574511F973@bugzilla.kernel.org>
References: <bug-32122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56231 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab2ENOfM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 May 2012 10:35:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 059BB20420
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 14:35:11 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 4E3FF2041B
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2012 14:35:09 +0000 (UTC)
In-Reply-To: <bug-32122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32122


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
