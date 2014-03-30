From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sun, 30 Mar 2014 15:19:07 +0000
Message-ID: <bug-23732-13602-D1nSbCcyNb@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60242 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaC3PTK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 11:19:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CF5FB203A9
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:19:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 290A82024D
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:19:08 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #4 from Conrad Meyer <cse.cem@gmail.com> ---
(Which we expect, given:)

$ echo $((1970+(2038-1970)*4))
2242

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
