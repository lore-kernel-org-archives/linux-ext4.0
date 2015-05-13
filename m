From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96641] Oops in __d_lookup when accessing certain files
Date: Wed, 13 May 2015 14:57:36 +0000
Message-ID: <bug-96641-13602-1i1iQWO3QX@https.bugzilla.kernel.org/>
References: <bug-96641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40820 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbbEMO5m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 May 2015 10:57:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1323D2042A
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 14:57:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6A787203EB
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2015 14:57:36 +0000 (UTC)
In-Reply-To: <bug-96641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=96641

dann frazier <dannf@dannf.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #4 from dann frazier <dannf@dannf.org> ---
I'm going to mark this as resolved for the following reasons:

 - I reinstalled the system and the issue persisted.
 - I was unable to reproduce on another, identically configured system.
 - After removing one of the two DIMMs, the system is no longer seeing the
problem.

This all points to a localized hardware failure.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
