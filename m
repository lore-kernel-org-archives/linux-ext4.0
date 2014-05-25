From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76821] jbd2 write on disk each 2/3 seconds
Date: Sun, 25 May 2014 09:06:35 +0000
Message-ID: <bug-76821-13602-3KewHtNpGH@https.bugzilla.kernel.org/>
References: <bug-76821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53449 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaEYJGi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2014 05:06:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8A7F8202C8
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 09:06:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9FDFD20222
	for <linux-ext4@vger.kernel.org>; Sun, 25 May 2014 09:06:35 +0000 (UTC)
In-Reply-To: <bug-76821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76821

--- Comment #3 from Abdelhak Bougouffa <abdelhak@cryptolab.net> ---
Hi, 
Thank you Mr. Theodore

So, I tried this commands, and I get a big number of process! 

I observed that the kworker is not really the cause! the systemd-journal is
writing all times to the disk!, When I traced one of his used inodes, I found
it writing to /var/log/journal/****.journal, each time a file of 8MB.

http://pastebin.com/W3yu3SVH

It's notable that the debugging options:
    CONFIG_FUNCTION_TRACER
    CONFIG_FUNCTION_GRAPH_TRACER
    CONFIG_STACK_TRACER
    CONFIG_DYNAMIC_FTRACE

Are enabled in my working kernel (I installed it using the Arch repository)

Thanks!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
