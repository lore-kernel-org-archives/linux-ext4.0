From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] access to file does not change access time to folders
 above up to /(root)
Date: Fri, 05 Feb 2016 08:31:20 +0000
Message-ID: <bug-111891-13602-fg7Ullaml5@https.bugzilla.kernel.org/>
References: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53783 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbcBEIbX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 03:31:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0FF2A202F8
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 08:31:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A1DB02039E
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 08:31:20 +0000 (UTC)
In-Reply-To: <bug-111891-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

--- Comment #3 from Armin Mohring <armin_mohring@web.de> ---
I think, only symbolic links should be used.

The parent directory is given by the directory tree itself. Stored in a tree.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
