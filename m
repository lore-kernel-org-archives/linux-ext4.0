From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Tue,  3 Mar 2009 21:43:26 -0800 (PST)
Message-ID: <20090304054326.7DBB410800D@picon.linux-foundation.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbZCDFn3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 00:43:29 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n245hQ3G002569
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 21:43:27 -0800
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151





------- Comment #5 from sandeen@redhat.com  2009-03-03 21:43 -------
oh, and; a boot-time fsck on fedora root filesystems probably means the fs was
marked w/ errors prior to the shutdown.  You might look in your logs to see if
there's anything there.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
