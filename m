From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78151] e2image -I does not work on ext4?
Date: Tue, 17 Jun 2014 12:56:45 +0000
Message-ID: <bug-78151-13602-vwqQXkia5p@https.bugzilla.kernel.org/>
References: <bug-78151-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37584 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbaFQM4z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 08:56:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 42766202F8
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 12:56:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9579B202AE
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2014 12:56:45 +0000 (UTC)
In-Reply-To: <bug-78151-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78151

--- Comment #2 from J. B. <barth@ub.uni-heidelberg.de> ---
Thanks a lot.

I've stored tons of data on an almost static ext4 filesystem. Just in the rare
case when adding more data (deletion does not occur in this case), the
filesystem gets modified.

Additionally, there's a md5 database for each file (out-of-band), so *tought*
recovery could be done quick in case of "admin errors" or "head crash on large
inode region".

(Multiple versions of e2image would be requierd then, of course).

Kind regards,
Jochen

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
