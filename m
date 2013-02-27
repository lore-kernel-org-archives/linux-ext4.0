From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 54551] write fails with one short >2GB write.
Date: Wed, 27 Feb 2013 14:51:38 +0000 (UTC)
Message-ID: <20130227145138.982BD11FBAA@bugzilla.kernel.org>
References: <bug-54551-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60554 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3B0Ovm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 09:51:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3D61420378
	for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2013 14:51:40 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9ADA420323
	for <linux-ext4@vger.kernel.org>; Wed, 27 Feb 2013 14:51:38 +0000 (UTC)
In-Reply-To: <bug-54551-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=54551





--- Comment #1 from meetmehiro@gmail.com  2013-02-27 14:51:38 ---
is it like, "MAX_RW_COUNT" limit is 2G ?????

is there any way, we can bypass this limit, pls help me out into this..

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
