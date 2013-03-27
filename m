From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55821] kernel oops when unmounting ext3 fs
Date: Wed, 27 Mar 2013 11:38:46 +0000 (UTC)
Message-ID: <20130327113846.141B611FB3C@bugzilla.kernel.org>
References: <bug-55821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3C0Lis (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 07:38:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1F86D2034F
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 11:38:47 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1609120349
	for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 11:38:46 +0000 (UTC)
In-Reply-To: <bug-55821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55821





--- Comment #1 from David Maciejak <dmaciejak@fortinet.com>  2013-03-27 11:38:45 ---
Created an attachment (id=96361)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=96361)
ext3 poc file

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
