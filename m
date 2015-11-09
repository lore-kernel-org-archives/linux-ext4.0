From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Mon, 09 Nov 2015 18:13:16 +0000
Message-ID: <bug-107301-13602-XXgQsHgUtV@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54373 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbbKISN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2015 13:13:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3D44F20663
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 18:13:25 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9F92020680
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2015 18:13:16 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #12 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
Created attachment 192551
  --> https://bugzilla.kernel.org/attachment.cgi?id=192551&action=edit
add "no_mbcache

We have a patch for Lustre ldiskfs (ext4 modified with Lustre patches) to
disable mbcache, since it has similar performance impact for Lustre servers,
and provides no value because the xattrs Lustre stores on each file are unique
and cannot be shared.  

Canonical patch location:
http://git.hpdd.intel.com/fs/lustre-release.git/blob_plain/HEAD:/ldiskfs/kernel_patches/patches/rhel7/ext4-disable-mb-cache.patch

While the referenced patch is for RHEL 7, it is small enough to port easily to
the upstream kernel.

This patch adds a "no_mbcache" mount option, which Lustre automatically adds to
the filesystem options when the servers are mounted.  There was a patch to
improve mbcache performance in ext4 by making the cache per-sb, but that
doesn't improve the contention within a filesystem, and doesn't avoid the fact
that mbcache provides absolutely no value for Lustre (or Ceph, it seems). 
Doing no work at all is better than doing it somewhat more efficiently.

The only way I could see this working automatically is if mbcache disabled
itself after having a low/zero cache hit ratio within a certain number of
inserts, and if not finding any shared xattr blocks when reading from disk.  In
the meantime, I think having a mount option is a viable alternative for those
people who know better than the auto-detection heuristics.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
