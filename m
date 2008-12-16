From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Tue, 16 Dec 2008 12:35:43 -0800 (PST)
Message-ID: <20081216203543.76CEF10800F@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbYLPUgC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2008 15:36:02 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBGKZhRF022826
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2008 12:35:44 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #8 from csights@fastmail.fm  2008-12-16 12:35 -------
http://bugzilla.kernel.org/show_bug.cgi?id=12224

Hi all,
        You might be interested to know that this problem can be reproduced by
using 
an ext3 image file mounted loopback.  (I.e. You don't need a separate 
harddrive or partition in order to reproduce the problem.)

C.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
