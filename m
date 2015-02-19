From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Thu, 19 Feb 2015 19:22:42 +0000
Message-ID: <bug-23732-13602-xTaOQrPzAx@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbbBSTWp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2015 14:22:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B6DBB20328
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 19:22:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1FDB720103
	for <linux-ext4@vger.kernel.org>; Thu, 19 Feb 2015 19:22:43 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #7 from Alan <alan@lxorguk.ukuu.org.uk> ---
I don't have the number. I re-ran your test case

[root@localhost next]# touch -d 2038-01-31 test-123
[root@localhost next]# ls -l test-123
-rw-r--r--. 1 root root 0 Jan 31  2038 test-123
[root@localhost next]# echo 3 >/proc/sys/vm/drop_caches 
[root@localhost next]# ls -l test-123
-rw-r--r--. 1 root root 0 Jan 31  2038 test-123

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
