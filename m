From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Tue,  3 Mar 2009 21:33:33 -0800 (PST)
Message-ID: <20090304053333.1003410800D@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbZCDFdf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 00:33:35 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n245XXek001864
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 21:33:34 -0800
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #2 from sandeen@redhat.com  2009-03-03 21:33 -------
Depending on what you see from sysrq, this is probably fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2acf2c261b823d9d9ed954f348b97620297a36b5

which may make it to .28.y eventually...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
