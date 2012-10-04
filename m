From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48301] Kernel panic when try delete really big file (3,3TB)
Date: Thu,  4 Oct 2012 05:44:24 +0000 (UTC)
Message-ID: <20121004054424.598DE11FC3E@bugzilla.kernel.org>
References: <bug-48301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35567 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab2JDFo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 01:44:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C2ED4202CA
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 05:44:25 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 5B9FF202C7
	for <linux-ext4@vger.kernel.org>; Thu,  4 Oct 2012 05:44:24 +0000 (UTC)
In-Reply-To: <bug-48301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48301





--- Comment #1 from Zdenek Zdvorak <zdenek@zdvorak.eu>  2012-10-04 05:44:24 ---
Created an attachment (id=82021)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=82021)
DMESG, system info

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
