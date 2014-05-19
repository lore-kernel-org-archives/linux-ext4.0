From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 75621] Permission denied trying to touch a file; happens
 randomly; both ext3 and GPFS
Date: Mon, 19 May 2014 13:18:11 +0000
Message-ID: <bug-75621-13602-oAklTu7oHx@https.bugzilla.kernel.org/>
References: <bug-75621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34216 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbaESNSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2014 09:18:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 817D22018A
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 13:18:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 77CEB20221
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 13:18:11 +0000 (UTC)
In-Reply-To: <bug-75621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=75621

--- Comment #2 from plvbr <phillip.l.viana@gmail.com> ---
I couldn't reproduce it ever again. I reproduced it two or three times then it
never happened. But as I said it happens on an ext3 system as well. Not sure if
it would still happen on ext3 if I didn't have GPFS compiled.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
