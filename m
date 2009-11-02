From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 2 Nov 2009 17:05:46 GMT
Message-ID: <200911021705.nA2H5kHJ022851@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51219 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbZKBRFn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Nov 2009 12:05:43 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA2H5k7T022852
	for <linux-ext4@vger.kernel.org>; Mon, 2 Nov 2009 17:05:46 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #167 from Eric Sandeen <sandeen@redhat.com>  2009-11-02 17:05:38 ---
My test overnight ran successfully through > 100 iterations of the test, on a
tree checked out just prior to d0646f7b636d067d715fab52a2ba9c6f0f46b0d7.

This morning I ran that same tree with the journal checksums enabled via mount
option, saw that journal corruption was found by the checksumming code, and
immediately after that we saw the corruption.  So it is the checksum feature
being on which is breaking this for us.

Linus, I would recommend reverting d0646f7b636d067d715fab52a2ba9c6f0f46b0d7 for
now, at this late stage in the game, and those present on the ext4 call this
morning agreed.

A few things seem to have gone wrong; for one we should have at least issued a
printk when we found a bad journal checksum but we silently continued on thanks
to a RDONLY check (and the root fs is mounted readonly...)

My hand-wavy hunch about what is happening is that we're finding a bad checksum
on the last partially-written transaction, which is not surprising, but if we
have a wrapped log and we're doing the initial scan for head/tail, and we abort
scanning on that bad checksum, then we are essentially running an unrecovered
filesystem.

But that's hand-wavy and I need to go look at the code.

We lived without journal checksums on by default until now, and at this point
they're doing more harm than good, so we should revert the default-changing
commit until we can fix it and do some good power-fail testing with the fixes
in place.

I'll revert that patch and do another overnight test on an up-to-date tree to
be sure nothing else snuck in, but this looks to me like the culprit, and I'm
comfortable recommending that the commit be reverted for now.

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
