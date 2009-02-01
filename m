From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Sun,  1 Feb 2009 15:35:03 -0800 (PST)
Message-ID: <20090201233503.4714310800E@picon.linux-foundation.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZBAXfh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 18:35:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n11NZ3Sc030025
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 15:35:04 -0800
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603





------- Comment #1 from sandeen@redhat.com  2009-02-01 15:35 -------
In case there is some thread that is hung up, can you try sysrq-w (echo w >
/proc/sysrq-trigger) and see what you get in dmesg?  (you can attach that here)

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
