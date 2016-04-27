From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 113041] mbcache NULL pointer dereference
Date: Wed, 27 Apr 2016 21:35:28 +0000
Message-ID: <bug-113041-13602-nOQwBNKUR9@https.bugzilla.kernel.org/>
References: <bug-113041-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55009 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbcD0Vfc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Apr 2016 17:35:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 777C02025A
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 21:35:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 46F7620268
	for <linux-ext4@vger.kernel.org>; Wed, 27 Apr 2016 21:35:28 +0000 (UTC)
In-Reply-To: <bug-113041-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=113041

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #7 from Theodore Tso <tytso@mit.edu> ---
The comm field doesn't really matter all that much.  The crash is in the
mbcache slab shrinker, which gets called from the VM when the system us under
memory pressure.

It looks like the crash is in the extended attribute cache which is in turn
triggered by SELinux.   (As far as I know Cassandra doesn't use extended
attributes.)

Note that the 4.3.x kernel is not a long-term supported kernel, and it's no
longer automatically getting bug fixes ported to it, at least not in the
upstream.  If CoreOS is providing their own security updates, then you should
really ask them for support because this would be a distro-kernel that has
changes not seen or supported by usptream developers.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
