From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Wed, 13 Jan 2010 22:16:05 GMT
Message-ID: <201001132216.o0DMG5mK014497@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52821 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab0AMWQG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 17:16:06 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0DMG5u7014498
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 22:16:05 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #2 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-01-13 22:16:04 ---
On Wed, Jan 13, 2010 at 10:09:32PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> --- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2010-01-13 22:09:30 ---
> Since you marked it as a regression, what was the last working kernel?

I upgraded from 2.6.32-rc5, where I didn't see this issue. 2.6.32.3 works
fine on the same machine and filesystem.

/* Steinar */

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
