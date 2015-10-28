From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] Oops in __d_lookup when accessing certain files
Date: Wed, 28 Oct 2015 18:04:57 +0000
Message-ID: <bug-96641-13602-3aPKDtN87X@https.bugzilla.kernel.org/>
References: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59672 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbbJ1SFG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Oct 2015 14:05:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 83595208C3
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 18:05:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0EF38208C0
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 18:04:58 +0000 (UTC)
In-Reply-To: <bug-96641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

dann frazier <dannf@dannf.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Resolution|UNREPRODUCIBLE              |INVALID

--- Comment #5 from dann frazier <dannf@dannf.org> ---
fyi, this was root caused to be a firmware bug and has been resolved with the
1.15.22 firmware release.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
