From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 03:52:50 +0000
Message-ID: <bug-76261-13602-QSPXKkxUGj@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55170 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaEPDwx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 23:52:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2BC5620395
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:52:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B7566202E9
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:52:50 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #7 from Theodore Tso <tytso@mit.edu> ---
Look, if you're complaining about long shutdown times, you can do a forced
shutdown.  You will then lose data.  If you care about not losing data, then
you have to wait for all of the data to be written out to flash.  There's no
magic pixie dust here.  You can have a clean shutdown that might take a little
while, and no data loss, or you can live with the potential risk of data loss
if you can't stand waiting even a tiny bit of time for the shutdown to finish
up.

The other question is why is some user process writing so much to the file
system before the system is shutdown.  Is this really some ill-behaved user
application which is burning huge amounts of flash lifespan and battery life by
constantly writing to flash?   Or is there some other bug going on which is
causing system processes to write huge amounts of logs or other junk to the
file system unnecessarily?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
