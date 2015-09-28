From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 105121] lseek(SEEK_DATA) hangs for a long time for sparse files
 in the page cache
Date: Mon, 28 Sep 2015 15:15:29 +0000
Message-ID: <bug-105121-13602-AQKdWQF0gI@https.bugzilla.kernel.org/>
References: <bug-105121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933554AbbI1PPf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 11:15:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7A35B2073F
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 15:15:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AE6D92073D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 15:15:29 +0000 (UTC)
In-Reply-To: <bug-105121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
This implies that grep is using lseek(SEEK_DATA) as an optimization when users
use grep on sparse files.   So I'm guessing this is a Thing, but I'm at a loss
why people are interested in running grep on a sparse file (with or without
blocks preallocated using fallocate).   Can you enlighten me as to why people
(or at least you and your colleague) find it useful to run grep on such files?

Not that it matters since this is a pretty clear optimization we should add to
ext4; I'm just curious what the use case is.

Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
