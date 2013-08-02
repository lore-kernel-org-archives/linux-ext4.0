From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60676] Stat system call gives permission denied to root for
 links under a sticky bit
Date: Fri, 02 Aug 2013 00:44:35 +0000
Message-ID: <bug-60676-13602-zhtxmg3pVa@https.bugzilla.kernel.org/>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41673 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3HBAoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 20:44:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 418FD201F3
	for <linux-ext4@vger.kernel.org>; Fri,  2 Aug 2013 00:44:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B3A6D20182
	for <linux-ext4@vger.kernel.org>; Fri,  2 Aug 2013 00:44:35 +0000 (UTC)
In-Reply-To: <bug-60676-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60676

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
On Thu, Aug 01, 2013 at 11:21:16AM -0700, Christoph Hellwig wrote:
> Try reverting 800179c9b8a1e796e441674776d11cd4c05d61d7

Or just do:

echo 0 > /proc/sys/fs/protected_hardlinks
echo 0 > /proc/sys/fs/protected_symlinks

(or put the equivalent in /etc/sysctl.conf).

There is a **very** detailed description of the design decision behind
this change (which went in as of 3.6) in the commit description.  See:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=800179c9b8a1e796e441674776d11cd4c05d61d7

In any case, it's "working as designed".

                        - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
