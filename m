From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Thu, 13 Nov 2014 14:33:15 +0000
Message-ID: <bug-86471-13602-kJaqEa7QbM@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37726 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbaKMOdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 09:33:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 75DF120220
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:33:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0B8332021B
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2014 14:33:16 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86471

--- Comment #10 from JPT <j-p-t@gmx.net> ---
Found it: Was moved to here, correct?
https://bugzilla.kernel.org/show_bug.cgi?id=86831

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
