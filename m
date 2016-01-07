From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Thu, 07 Jan 2016 15:49:40 +0000
Message-ID: <bug-108631-13602-wkkdU1bCEc@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36153 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbcAGPto (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 10:49:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 64A30200FE
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 15:49:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 23841201B9
	for <linux-ext4@vger.kernel.org>; Thu,  7 Jan 2016 15:49:41 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
You said that you had replicated this problem on 4.2, so it's probably not the
primary driver of the problem in your case, but be aware that in some of the
older kernels (and 3.14 is included in that list), the shrinker is not cgroup
aware.   That means that if a single container starts aggressively using all of
its memory, we will start kicking off *all* of the slab cache shrinkers.   I've
seen that in a very container-heavy environment, with many tasks that use right
up to their memory cgroup limit (and sometimes beyond), that this can cause the
ext4 extent status cache shrinker to end up getting run a lot, which leads to
symptoms similar to yours due to spinlock contention.  (Of course, for a
different spinlock since a different slab cache shrinker is involved).

I've been playing with some patches to use trylock and to abandon the ext4 es
shrinker if it's under too much lock contention, but I haven't come up with
something for which I was sufficiently happy to push upstream yet --- because
if the slab cache does need shrinker, just simply giving up isn't going to do
the right thing entirely, either.

One hacky solution would be to add knobs so we can cap the size of various
caches like the mbcache and extents status cache so we can afford to be more
aggressive at giving up if the trylock fails.  But assuming that system
administrators will *set* these knobs correctly is probably a bad choice.  So
this is a more general problem than just the mbcache, and I haven't found a
good general solution yet.  And there may not be; we can try to make systems
that are less likely to lead to spinlock contention, but under sufficiently
heavy memory pressure, this may only be forestalling the inevitable.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
