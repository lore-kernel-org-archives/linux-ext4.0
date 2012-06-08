From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] Corruption on a small loopback ext4 file system with
 Linux 3.4
Date: Fri,  8 Jun 2012 13:44:13 +0000 (UTC)
Message-ID: <20120608134413.41AE01205D7@bugzilla.kernel.org>
References: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49580 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab2FHNoU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 09:44:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 71D84202E1
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 13:44:19 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 49DD5203E1
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 13:44:13 +0000 (UTC)
In-Reply-To: <bug-43354-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354





--- Comment #3 from Alec Moskvin <alecm@gmx.com>  2012-06-08 13:44:13 ---
Yes, it seems to work fine with the 4k block size.
mkfs.ext4 -T small -N 200000 -b 4096 tree.ext4

(Of course, I had to also double the image size because otherwise the data
won't fit, but the size does not have an effect - the above is reproducible
with a 1G image as well.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
