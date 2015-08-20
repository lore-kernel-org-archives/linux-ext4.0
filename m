From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 103111] auto_da_alloc mount option not working
Date: Thu, 20 Aug 2015 05:53:20 +0000
Message-ID: <bug-103111-13602-g0pgTJP6ce@https.bugzilla.kernel.org/>
References: <bug-103111-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbbHTFxY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2015 01:53:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 95A6F20376
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2015 05:53:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BAF6620380
	for <linux-ext4@vger.kernel.org>; Thu, 20 Aug 2015 05:53:20 +0000 (UTC)
In-Reply-To: <bug-103111-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=103111

--- Comment #3 from Rakesh <patelrakeshcomp@gmail.com> ---
Same behaviour on kernel 3.14.27 also.

Power cut for 15sec, 20sec and 25sec. All 3times, files is having zero length.

For above code file "example.txt1" is empty.

If I remove rename command(system(mv example.txt example.txt1)) then also
example.txt is blank.

  ofstream myfile;

  myfile.open ("example.txt",std::ofstream::trunc);

  myfile << "Writing this to a file.\n";

Looks like rename via trunc call is not wroking.

Uploaded sample file.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
