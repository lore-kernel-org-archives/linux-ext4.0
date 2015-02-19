From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Thu, 19 Feb 2015 16:01:32 +0000
Message-ID: <bug-23732-13602-KnRmx84QDp@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbbBSQBf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 11:01:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1B768202FF
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:01:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A9873202BE
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 16:01:32 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
