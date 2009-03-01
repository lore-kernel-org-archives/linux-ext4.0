From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Sun,  1 Mar 2009 12:53:44 -0800 (PST)
Message-ID: <20090301205345.11ADE10800D@picon.linux-foundation.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbZCAUxt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Mar 2009 15:53:49 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n21KrjSl022802
	for <linux-ext4@vger.kernel.org>; Sun, 1 Mar 2009 12:53:46 -0800
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787





------- Comment #5 from marko.kohtala@gmail.com  2009-03-01 12:53 -------
I applied fb68407b0d9efba962c03f55009c797e22f024bc to 2.6.28.7 and it seemes to
have removed the bug.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
