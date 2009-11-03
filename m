From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Tue, 3 Nov 2009 01:07:02 GMT
Message-ID: <200911030107.nA3172Wh031424@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59085 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZKCBG7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 20:06:59 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA3172tA031425
	for <linux-ext4@vger.kernel.org>; Tue, 3 Nov 2009 01:07:02 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #169 from Linus Torvalds <torvalds@linux-foundation.org>  2009-11-03 01:06:56 ---
On Mon, 2 Nov 2009, Eric Sandeen <sandeen@redhat.com> wrote:
>
> if the folks who saw this could revert d0646f7b636d067d715fab52a2ba9c6f0f46b0d7
> (or just pull Linus' git tree, because he's reverted it upstream) and retest
> your scenarios that'd be great.

I've done a few dirty reboots on the laptop that was showing the problem 
(trying to intentionally blow things up by rebooting in the middle of a 
kernel compile), and have yet to see the kinds of problems I had 
originally.

Instead of getting problems with "lookup()" finding deleted inodes, I get 
orphan cleanup during recovery, and the filesystem looks ok. I get 
truncated files in the compile (and need to remove the bad *.o files), 
but that's what I'd _expect_ from killing the machine in the middle of a 
compile.

So I think you nailed it with the revert.

            Linus

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
