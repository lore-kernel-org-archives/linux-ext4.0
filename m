From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sun, 30 Mar 2014 15:08:08 +0000
Message-ID: <bug-23732-13602-VJWKHvz4rY@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaC3PIL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 11:08:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4EEBB203AC
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:08:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 72AA720386
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:08:08 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #2 from Conrad Meyer <cse.cem@gmail.com> ---
Patch submitted, seems to fix the issue on my system.

https://lkml.org/lkml/2014/3/30/40

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
