From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 11 Oct 2009 02:03:13 GMT
Message-ID: <200910110203.n9B23DW6018741@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37249 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbZJKCDu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Oct 2009 22:03:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9B23DOj018742
	for <linux-ext4@vger.kernel.org>; Sun, 11 Oct 2009 02:03:13 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #12 from Theodore Tso <tytso@mit.edu>  2009-10-11 02:03:12 ---
When the file system gets remounted read-only, can you please send the output
of the "dmesg" command?   If you don't have an extra file system where you can
save the dmesg output, please do "dmesg | grep -i ext4" and copy down what you
see.  Thanks!!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
