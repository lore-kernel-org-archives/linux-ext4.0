From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Sat, 2 May 2009 16:29:30 GMT
Message-ID: <200905021629.n42GTU6W031805@demeter.kernel.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52563 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbZEBQ3a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 May 2009 12:29:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n42GTU6I031806
	for <linux-ext4@vger.kernel.org>; Sat, 2 May 2009 16:29:30 GMT
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





--- Comment #10 from Nathan Grennan <kernel-bugzilla@cygnusx-1.org>  2009-05-02 16:29:29 ---
  Here is my basic experience with ext4. I had two basic problems.

 One was where the system would just go off into a hang. The other was this
issue. This issue went away when I went with a 2.6.28+ kernel. Backporting
patches didn't work for me. I say this because at the time you guys were
telling me there were no new patches, but I would have issue with 2.6.27
kernels, but not 2.6.28 kernels. Later cebbert said there was something nasty
in 2.6.28.1 kernels, so I upgraded to 2.6.29. I have had zero issues with ext4
since upgrading to 2.6.29.

  I just looked through my irc logs, and found the errors that I think caused
this problem. Sandeen, I have mentioned these to you before. How I think it
would go would be I would get one of these errors, the system would continue,
because that is the crazy default. Then a few days later, I having not noticed
these errors, would reboot the system, and receive the fsck issue above. From
what I remember reading this issue was fixed.

Feb 16 12:03:19 proton kernel: EXT4-fs error (device md3):
ext4_mb_generate_buddy: EXT4-fs: group 
EXT4-fs error (device md3): mb_free_blocks: double-free of inode 0's block
321550248(bit 30632 in group 9812)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
