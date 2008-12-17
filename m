From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12018] oops when using ext4 on soft raid on IA64 with 65536 block size
Date: Tue, 16 Dec 2008 21:50:16 -0800 (PST)
Message-ID: <20081217055016.412C510800E@picon.linux-foundation.org>
References: <bug-12018-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYLQFus (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2008 00:50:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBH5oG9t025977
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2008 21:50:17 -0800
In-Reply-To: <bug-12018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12018





------- Comment #1 from tytso@mit.edu  2008-12-16 21:50 -------
Created an attachment (id=19341)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19341&action=view)
Proposed patch provided by Yasunori Goto

This patch was provided by Yasunori Goto and should fix this bug.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
