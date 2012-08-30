From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] ext4 deadlock under heavy io?
Date: Thu, 30 Aug 2012 13:34:53 +0000 (UTC)
Message-ID: <20120830133453.75BDB11FA5F@bugzilla.kernel.org>
References: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53209 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab2H3Ne7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Aug 2012 09:34:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B344202B9
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 13:34:58 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 79091202BD
	for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 13:34:53 +0000 (UTC)
In-Reply-To: <bug-44731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731





--- Comment #13 from Mirek Rusin <mirek@me.com>  2012-08-30 13:34:53 ---
Created an attachment (id=78801)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=78801)
echo w > /proc/sysrq-trigger output on frozen filesystem.

Added attachment with output from "echo w > /proc/sysrq-trigger" on frozen fs.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
