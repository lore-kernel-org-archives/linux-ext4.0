From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Tue, 12 Jul 2016 04:42:10 +0000
Message-ID: <bug-121371-13602-JnQtjXJPeO@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56474 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbcGLEmP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2016 00:42:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 98D1E20254
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jul 2016 04:42:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 670E320259
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jul 2016 04:42:11 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

--- Comment #8 from Navin <navinp1912@gmail.com> ---
Isn't it the bug of fsck that it didn't fix that ?
Yes and No.

Yes when the bug can be legitimately reproduced from calling API/exported
functions with valid values or with tools and commands. 

No when you have corrupted values in images due to incorrect writes or flushes
by device or binary etc.

Maybe fsck can be modified in this particular case of i_flags which are valid
and rest all invalid. You will have to check on linux-ext4 list whether it is
such a value or not. Also if possible provide a patch later.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
