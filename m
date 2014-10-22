From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86471] drastic reduction of write performance after the
 termination of mysqld
Date: Wed, 22 Oct 2014 20:22:55 +0000
Message-ID: <bug-86471-13602-rB1bknwNLA@https.bugzilla.kernel.org/>
References: <bug-86471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42383 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbaJVUW6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 16:22:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4BE072026C
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 20:22:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C28F02025B
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 20:22:55 +0000 (UTC)
In-Reply-To: <bug-86471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86471

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
Are you sure this is actually a problem?    Could it just be that when mysqld
shuts down, it's issuing a huge number of buffered writes which is just taking
a long, long time to get written out to your eMMC device (which is typically
very, *very* slow to handle writes).

I had suggested using blktrace to see if I/O is going on.   You could also try
looking using iostat or the dstat program.   If it's just that I/O is still
happening, then things may be working normally --- just that eMMC might be a
bad match with a high performance database workload.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
