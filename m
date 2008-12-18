From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Thu, 18 Dec 2008 12:41:06 -0800 (PST)
Message-ID: <20081218204106.09A4811D108@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbYLRUmC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2008 15:42:02 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBIKf6S1023293
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 12:41:07 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #11 from rjw@sisk.pl  2008-12-18 12:41 -------
Handled-By : Eric Sandeen <sandeen@redhat.com>
Notify-Also : Theodore Tso <tytso@mit.edu>
First-Bad-Commit : c87591b719737b4e91eb1a9fa8fd55a4ff1886d6


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
