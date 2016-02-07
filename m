From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111891] access to file does not change access time to folders
 above up to /(root)
Date: Sun, 07 Feb 2016 09:59:54 +0000
Message-ID: <bug-111891-13602-EY8MHhafDh@https.bugzilla.kernel.org/>
References: <bug-111891-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbcBGJ76 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Feb 2016 04:59:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5EC69200E3
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 09:59:57 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BA1D820211
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 09:59:54 +0000 (UTC)
In-Reply-To: <bug-111891-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111891

--- Comment #6 from Armin Mohring <armin_mohring@web.de> ---
Just backtrace the directory tree.
Modern firesystems use trees for storing the directory information.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
