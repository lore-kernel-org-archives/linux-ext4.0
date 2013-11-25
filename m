From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] oops: fs/ext4/ext4_jbd2.c
Date: Mon, 25 Nov 2013 09:39:00 +0000
Message-ID: <bug-65701-13602-3dsR8uyN9z@https.bugzilla.kernel.org/>
References: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38926 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3KYJjL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Nov 2013 04:39:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7463C20265
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 09:39:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1E3532022F
	for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 09:39:01 +0000 (UTC)
In-Reply-To: <bug-65701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

--- Comment #2 from Dmitry Monakhov <dmonakhov@openvz.org> ---
Created attachment 115861
  --> https://bugzilla.kernel.org/attachment.cgi?id=115861&action=edit
this patch should fix an issue

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
