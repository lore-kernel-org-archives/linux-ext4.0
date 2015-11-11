From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Wed, 11 Nov 2015 11:37:33 +0000
Message-ID: <bug-107301-13602-tVCgGqf6Fh@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49941 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbbKKLhh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2015 06:37:37 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4B92020675
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 11:37:36 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 28262205EA
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2015 11:37:34 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #16 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
I think that regardless of how efficient mbcache can be made, it is not as
efficient (both CPU and RAM) as not using it at all in cases where it is not
providing any benefit.  I'm not against improving the efficiency, but I think
it still makes sense to have an option to disable it completely. Since mbcache
is already a per-sb cache, having a per-sb mount option makes sense and doesn't
interfere with other improvements to mbcache.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
