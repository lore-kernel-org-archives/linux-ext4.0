From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Tue, 26 Jan 2010 23:20:21 GMT
Message-ID: <201001262320.o0QNKLM5025101@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34449 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0AZXUV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jan 2010 18:20:21 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0QNKL1D025102
	for <linux-ext4@vger.kernel.org>; Tue, 26 Jan 2010 23:20:21 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018





--- Comment #5 from Jan Kara <jack@suse.cz>  2010-01-26 23:20:19 ---
Created an attachment (id=24739)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24739)
Patch fixing deadlock in ext4_da_reserve_space

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
