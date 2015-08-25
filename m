From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Tue, 25 Aug 2015 17:49:33 +0000
Message-ID: <bug-103111-13602-8MQRLFu2PJ@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbbHYRtg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2015 13:49:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C823620888
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 17:49:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3B5FF20881
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 17:49:34 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #10 from Eric Sandeen <sandeen@redhat.com> ---
Ok, so there are 2 basic heuristics here.

One is that if we call ext4_truncate to size 0, we set the AUTO_DA_ALLOC flag
so that it'll call ext4_alloc_da_blocks in ext4_release_file (essentially on
close).

The other is that if we call rename, and we're overwriting an existing file, we
call ext4_alloc_da_blocks.

ext4_alloc_da_blocks will start writeback on the file (i.e. the file which was
truncated, or the new file overwriting the old file) if there are any delayed
allocations still pending; if not, it does nothing.

Note, we don't get to ext4_truncate if the file is already zero length when you
open it O_TRUNC.

Also, notice that if we strace your c++ program (with the rename call
included), we see:

open("example.txt", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
rename("example.txt", "example.txt1")   = 0
write(3, "Writing this to a file.\n", 24) = 24
close(3)                                = 0

so the rename happens before the write; even if that is overwriting an existing
file, there are no delalloc blocks on the new file yet, so the rename heuristic
does nothing in this case.

So there are a few prerequisites to make your c++ test work

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
