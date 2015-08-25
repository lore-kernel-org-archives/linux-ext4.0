From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Tue, 25 Aug 2015 18:05:08 +0000
Message-ID: <bug-103111-13602-p1cj6XgNGT@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45206 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbbHYSFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2015 14:05:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C462F20887
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 18:05:11 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 591382086C
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 18:05:09 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #11 from Eric Sandeen <sandeen@redhat.com> ---
IOWS, it handles these two cases:

fd = open("foo.new")
write(fd,..)
close(fd)
rename("foo.new", "foo") // syncs out foo.new if it has delalloc blocks

and

fd = open("foo", O_TRUNC)
write(fd,..)
close(fd) // syncs out foo if "foo" had blocks prior to the O_TRUNC truncate

Your testcase does this if foo.new doesn't already exist:

fd = open("foo.new", O_TRUNC) // if foo.new has no blocks, O_TRUNC does nothing
rename("foo.new", "foo") // foo.new has no delalloc blocks, does nothing
write(fd)
close(fd) 

If "foo.new" does exist, 

fd = open("foo.new", O_TRUNC) // if foo.new has blocks, sets da_alloc flag
rename("foo.new", "foo") // foo.new has no delalloc blocks, does nothing
write(fd)
close(fd) // syncs out the data

IOWS, if example.txt starts with allocated blocks, this:

# rm example.txt1
# echo foobar > example.txt
# sync
# ./testcase

works as you hope, because testcase does:

fd = open("example.txt", O_TRUNC) // example.txt has blocks, sets da_alloc flag
rename("example.txt", "example.txt1") // "example.txt" no has delalloc blocks
nothing happens
write(fd) // now we have delalloc blocks
close(fd) // syncs out the data


So it's not that the heuristic is broken; your testcase just doesn't
necessarily meet the conditions of the heuristic.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
