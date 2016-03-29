From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115491] ext4_mb_generate_buddy, filesystem remounted read-only
Date: Tue, 29 Mar 2016 18:45:11 +0000
Message-ID: <bug-115491-13602-MWiiEx3ptX@https.bugzilla.kernel.org/>
References: <bug-115491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49403 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbcC2SpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2016 14:45:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 515A3202F8
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 18:45:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D28A42035B
	for <linux-ext4@vger.kernel.org>; Tue, 29 Mar 2016 18:45:11 +0000 (UTC)
In-Reply-To: <bug-115491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=115491

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
Are you running this under KVM?   The most recent spate of complaints about
this (which just means that ext4 discovered an inconsistency in the allocation
bitmaps; it doesn't automatically mean it's an ext4 bug) was caused by a bug in
the hypervisor layer of the Host OS.   See the resolution of this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=102731

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
