From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 07 Mar 2014 07:16:40 +0000
Message-ID: <bug-70121-13602-LhyKKCgh7t@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54946 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCGHQm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 02:16:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ED1F9202B4
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 07:16:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7B2C52027D
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 07:16:40 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #6 from sworddragon2@aol.com ---
> How does the file system know that the file has "successfully been
> written"?  Secondly, even if we did know, in order to guarantee the
> transaction semantics, we *always* update the journal first.  Only
> after the journals is updated, do we write back to the final location
> on disk.  So what you are suggesting just simply wouldn't work.

It seems it is just a too major change. Maybe it is something that could be
considered in ext5.


> it just
> makes it more likely, but if you crash at the wrong moment, you can
> still lose data


I have never seen a damaged file with full data journaling enabled. Can you
show me a race condition so that I can reproduce it? Hm, maybe it would be
possible if the journal is smaller than the file (I'm wondering what would
happen in such a case).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
