From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 105121] lseek(SEEK_DATA) hangs for a long time for sparse files
 in the page cache
Date: Mon, 28 Sep 2015 14:37:03 +0000
Message-ID: <bug-105121-13602-FbB79sEAG3@https.bugzilla.kernel.org/>
References: <bug-105121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34066 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039AbbI1OhJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 10:37:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CBDEA20749
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 14:37:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 70AD720738
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 14:37:03 +0000 (UTC)
In-Reply-To: <bug-105121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
            Summary|lseek() hangs for a long    |lseek(SEEK_DATA) hangs for
                   |time on allocated files     |a long time for sparse
                   |                            |files in the page cache

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
