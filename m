From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 105121] lseek(SEEK_DATA) hangs for a long time for sparse files
 in the page cache
Date: Mon, 28 Sep 2015 14:47:15 +0000
Message-ID: <bug-105121-13602-N20Orx3usd@https.bugzilla.kernel.org/>
References: <bug-105121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34399 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933318AbbI1OrS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 10:47:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E126B2073D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 14:47:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C7B3A20747
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 14:47:15 +0000 (UTC)
In-Reply-To: <bug-105121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Thanks for reporting this!

What's going on is that the "cat test > /dev/null" is instantiating 1GB of zero
pages in the page cache.

Currently, we are using the extent status to determine if a logical block is
mapped to a physical block.  However, the SEEK_DATA code dates back from a time
when we were not storing the status of delayed allocation blocks in the extent
status cache.  So if the extent status cache indicates that the blocks are
unwritten, the code which is handling fseek(SEEK_DATA) is scanning all of the
pages to determine if any of the unwritten blocks happen to be modified in
memory, but which haven't been pushed out to disk yet.

We should be able to optimize this (and simplify the code as a bonus) by using
the EXTENT_STATUS_DELAYED flag instead of trying to scan through all of the
page structs (with all of the locking requirements this entails).

Out of curiosity, what was the use case that caused you to notice this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
