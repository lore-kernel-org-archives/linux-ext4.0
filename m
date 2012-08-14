From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16583] ext4: delayed block allocation failed and application
 not respond any more
Date: Tue, 14 Aug 2012 07:35:40 +0000 (UTC)
Message-ID: <20120814073540.4D4B211FC6D@bugzilla.kernel.org>
References: <bug-16583-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50943 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab2HNHfn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 03:35:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0C2F620214
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 07:35:42 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 4CF94201EB
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2012 07:35:41 +0000 (UTC)
In-Reply-To: <bug-16583-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16583





--- Comment #4 from Loredan Stancu <salecss@gmail.com>  2012-08-14 07:35:39 ---
Hi Ted,

Thank you for your reply.


What I wanted to do was to shrunk the files system. This is why first I run
resize2fs (after unmounting and checking the file system with fsck.ext4).

Best Regards,
Loredan

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
