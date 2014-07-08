From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Tue, 08 Jul 2014 13:43:02 +0000
Message-ID: <bug-78651-13602-7reBRYKhrz@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43393 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbaGHNnF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 09:43:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C571F2014A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 036912015A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:43:03 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #11 from Joseph D. Wagner <joe@josephdwagner.info> ---
Created attachment 142471
  --> https://bugzilla.kernel.org/attachment.cgi?id=142471&action=edit
trace 256mb journal

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
