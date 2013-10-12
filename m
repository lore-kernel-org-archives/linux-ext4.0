From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 12 Oct 2013 00:17:12 +0000
Message-ID: <bug-61631-13602-g1HHJbqbs4@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34534 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3JLARS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Oct 2013 20:17:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BDA9220383
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:17:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E8C7B20348
	for <linux-ext4@vger.kernel.org>; Sat, 12 Oct 2013 00:17:16 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #10 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
Created attachment 110761
  --> https://bugzilla.kernel.org/attachment.cgi?id=110761&action=edit
dumpe2fs output before the umount and bug_on

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
