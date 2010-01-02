From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 2 Jan 2010 16:54:29 GMT
Message-ID: <201001021654.o02GsTBh017105@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48874 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0ABQya (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2010 11:54:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o02GsUSH017106
	for <linux-ext4@vger.kernel.org>; Sat, 2 Jan 2010 16:54:30 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972





--- Comment #5 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-01-02 16:54:28 ---
What debug options are needed for blktrace?

blktrace /dev/sda
Invalid debug path /sys/kernel/debug: 2/No such file or directory

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
