From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 19 Nov 2015 15:11:22 +0000
Message-ID: <bug-107301-13602-QVztKvQIpk@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbbKSPL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Nov 2015 10:11:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AB39A2065E
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2015 15:11:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 78EA520681
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2015 15:11:22 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #20 from Theodore Tso <tytso@mit.edu> ---
Apologies for not responding right away.  I'm currently on vacation.
So this also means that if someone sends me a patch right away, I'm
not likely to have time to look at it for a week or two.

As far as trying to make mbcache more scalable, this would be great,
but I suspect it's not going to be very easy because it requires a
global data structure, which is fundamentally hard to scale.  I can
imagine some schemes that sacrifice some of mbcache's ability to spot
duplicate xattr sets --- for example, you could just use a trylock,
and if there is lock contention just give up on detecting duplicate
xattrs.

Or maybe we could use some hueristics based on the xattr type/key to
decide whether using mbcache is likely to be successful.  So if we
know that Posix ACL's are very likely to be shared, and ceph xattrs
are very unlikely to be shared, this could be used to decide whether
or not to use mbcache automatically, without requiring a mount option.

Even better would be one where for unknonw xattr type/key
combinations, we use some learning algorithm which determines after
using mbcache for N instances of that xattr, if the percentage of
cache hits is too low, we stop using mbcache for that type/key
combination.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
