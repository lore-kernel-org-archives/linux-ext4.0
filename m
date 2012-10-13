From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] ext3: ctime changes with no reason in 30 seconds after a
 file change
Date: Sat, 13 Oct 2012 18:14:59 +0000 (UTC)
Message-ID: <20121013181459.B5CDA11F9D1@bugzilla.kernel.org>
References: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58158 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab2JMSPB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Oct 2012 14:15:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 91DFD20249
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:15:00 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BE39F201FD
	for <linux-ext4@vger.kernel.org>; Sat, 13 Oct 2012 18:14:59 +0000 (UTC)
In-Reply-To: <bug-48751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751


Vladimir A. Pavlov <pv4@bk.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Platform|i386                        |IA-32




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
