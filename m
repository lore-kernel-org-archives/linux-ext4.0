From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23732] ext4 timestamp range contains 68-year gaps
Date: Sun, 30 Mar 2014 15:18:20 +0000
Message-ID: <bug-23732-13602-2DatSHuWjp@https.bugzilla.kernel.org/>
References: <bug-23732-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60166 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaC3PSX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Mar 2014 11:18:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 12C77203AB
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:18:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4F8AF20386
	for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 15:18:20 +0000 (UTC)
In-Reply-To: <bug-23732-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23732

--- Comment #3 from Conrad Meyer <cse.cem@gmail.com> ---
34 (signed) bits of seconds gets us to Y2242:

$ touch -d 2242-01-01 test-123
$ sync ;sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"; sleep 1; sudo sh -c
"echo 3 > /proc/sys/vm/drop_caches"; sleep 1; ls -ld test-123
drwxrwxr-x 2 cmeyer cmeyer 4096 Jan  1  2242 test-123
$ touch -d 2243-01-01 test-123
$ sync ;sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"; sleep 1; sudo sh -c
"echo 3 > /proc/sys/vm/drop_caches"; sleep 1; ls -ld test-123
drwxrwxr-x 2 cmeyer cmeyer 4096 Aug  3  1698 test-123

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
