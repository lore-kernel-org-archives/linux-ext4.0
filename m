From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Wed, 18 Sep 2013 22:10:39 +0000
Message-ID: <bug-61631-13602-eukEBPWftG@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51924 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3IRWKn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 18:10:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5BEDF20412
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:10:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E9334203FD
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:10:39 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #3 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
I've done a full fsck -f -v -y on this filesystem using e2fsck 1.42.7
(21-Jan-2013).  umounts still result in a BUG.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
