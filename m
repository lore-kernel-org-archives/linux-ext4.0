From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Fri, 06 Nov 2015 02:43:17 +0000
Message-ID: <bug-107301-13602-4d84kGjvSi@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55006 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030909AbbKFCnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 21:43:21 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 130D420807
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 02:43:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7284020808
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 02:43:17 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
If Ceph is using xattrs that are all different for each inode, the mbcache is
not really useful at all.   So I wonder if we should have a mount option which
disables the mbcache.   This will prove the scalability of the xattr functions,
and should be a pretty big performance win for Ceph.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
