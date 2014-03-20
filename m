From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Thu, 20 Mar 2014 04:09:50 +0000
Message-ID: <bug-71641-13602-XwG9byeCbK@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44890 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaCTEJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2014 00:09:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0282D201C8
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2014 04:09:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 22416201C0
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2014 04:09:51 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #4 from Theodore Tso <tytso@mit.edu> ---
Could you retry your measurements using the latest kernel?  At least 3.11, and
preferably 3.13.

We significantly optimized the write path for the nodelalloc case in 3.11. 
That should fix the average size being so small for the nodelalloc case:


commit 20970ba65d5a22f2e4efbfa100377722fde56935
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jun 6 14:00:46 2013 -0400

    ext4: use ext4_da_writepages() for all modes

    Rename ext4_da_writepages() to ext4_writepages() and use it for all
    modes.  We still need to iterate over all the pages in the case of
    data=journalling, but in the case of nodelalloc/data=ordered (which is
    what file systems mounted using ext3 backwards compatibility will use)
    this will allow us to use a much more efficient I/O submission path.

    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
