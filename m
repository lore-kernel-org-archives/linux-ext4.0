From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45631] Caught 32-bit read from uninitialized memory in
 ext4_da_get_block_prep
Date: Sun,  5 Aug 2012 22:21:05 +0000 (UTC)
Message-ID: <20120805222105.05B4011FC6A@bugzilla.kernel.org>
References: <bug-45631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab2HEWVI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Aug 2012 18:21:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B740201CD
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:21:07 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 422B5201AC
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:21:06 +0000 (UTC)
In-Reply-To: <bug-45631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45631


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-08-05 22:21:04 ---
It's a false positive in that this isn't going to actually cause an actual bug;
we're just saving and restoring an uninitialized value if we have a error.  The
fact that we do this is no big deal, since if i_da_metadata_calc_len is zero,
the value of i_data_metadata_calc_last_lblock is never consulted.  So if we
save an uninitialized value, and then later restore it, it really doesn't
matter from a correctness point of view.

That being said, triggering a kmemcheck failure is sad, even if it's not a real
bug, so I agree we should fix it.  The most expedient and most efficient fix is
to simply initialize i_data_metadata_calc_last_lblock to zero in
ext4_alloc_inode(); this is where we initialize i_data_metadata_calc_len to
zero, and if we initialize the last_lblock to zero, it won't matter, and it
saves us from having to adding an extra conditional in
ext4_da_get_block_prep().

- Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
