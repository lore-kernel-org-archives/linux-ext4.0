From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Thu, 07 Jan 2016 14:10:14 +0000
Message-ID: <bug-108631-13602-Sxkf0tgbql@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbcAGOKV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 09:10:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 24EC6201CE
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 14:10:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A39E92017E
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 14:10:17 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

--- Comment #3 from Jan Kara <jack@suse.cz> ---
Created attachment 198911
  --> https://bugzilla.kernel.org/attachment.cgi?id=198911&action=edit
Patches fixing lockups with mbcache

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
