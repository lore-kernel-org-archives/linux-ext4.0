From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Sun, 24 Jan 2010 23:07:24 GMT
Message-ID: <201001242307.o0ON7Ovw013696@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39370 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0AXXHY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 18:07:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0ON7OKt013697
	for <linux-ext4@vger.kernel.org>; Sun, 24 Jan 2010 23:07:24 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #3 from Rafael J. Wysocki <rjw@sisk.pl>  2010-01-24 23:07:23 ---
On Sunday 24 January 2010, Steinar H. Gunderson wrote:
> On Sun, Jan 24, 2010 at 11:04:35PM +0100, Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> 
> I'm not using 2.6.33 anymore since this bug is a showstopper to me (it's on a
> production system), so I'm unable to check if it's fixed or not.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
