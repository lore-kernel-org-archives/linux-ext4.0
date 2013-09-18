From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Wed, 18 Sep 2013 22:07:22 +0000
Message-ID: <bug-61631-13602-5K1OSbNwsN@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51845 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3IRWHZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 18:07:25 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 81CE320411
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:07:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0A9D1203FB
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:07:23 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #2 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
Created attachment 108841
  --> https://bugzilla.kernel.org/attachment.cgi?id=108841&action=edit
dmesg including BUG message

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
