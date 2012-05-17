From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Thu, 17 May 2012 16:34:06 +0000 (UTC)
Message-ID: <20120517163406.8645111FCF6@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54595 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966148Ab2EQQeL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2012 12:34:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E974205DF
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 16:34:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 90FA0205B6
	for <linux-ext4@vger.kernel.org>; Thu, 17 May 2012 16:34:06 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #16 from Eugene <ivanovstm2@zmail.ru>  2012-05-17 16:34:06 ---
to Jan Kara, Theodore Ts'o:

Seems there is some difference in how various systems work (maybe specifics of
work of some hardware configurations and/or distro configuration choices). My
older system on 2.6.28 with ext3 had overall less HDD activity. And seems many
people are deceived by similar changes in system behavior into thinking that
something isn't right with the system. Which in turn leads them to notice jbd2
process and deduce that it's the main culprit in constant writes on disk since
information on jbd2 is scarce.

Thank you very much for your help and explanation.
I will try to point here people in launchpad's bug thread.

Eugene Ivanov

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
