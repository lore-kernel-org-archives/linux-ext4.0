From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] oops: fs/ext4/ext4_jbd2.c
Date: Tue, 26 Nov 2013 08:07:55 +0000
Message-ID: <bug-65701-13602-cZuhiaf9E3@https.bugzilla.kernel.org/>
References: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38383 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3KZIIE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Nov 2013 03:08:04 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9C9412039C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 08:07:58 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 800A120395
	for <linux-ext4@vger.kernel.org>; Tue, 26 Nov 2013 08:07:57 +0000 (UTC)
In-Reply-To: <bug-65701-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

--- Comment #4 from Dmitry Monakhov <dmonakhov@openvz.org> ---
BTW initial discussion started here:
http://marc.info/?t=134876094300003&r=1&w=2

# Original test case       
cat /mnt/test/fifo   
mkfifo /mnt/test/fifo
echo foo > /mnt/test/fifo &
fsfreeze -f /mnt/test      
cat /mnt/test/fifo

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
