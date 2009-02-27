From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Fri, 27 Feb 2009 10:23:29 -0800 (PST)
Message-ID: <20090227182329.990F611D108@picon.linux-foundation.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963AbZB0SYE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 13:24:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RINUQZ025412
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 10:23:31 -0800
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787





------- Comment #3 from aneesh.kumar@linux.vnet.ibm.com  2009-02-27 10:23 -------
I guess we need this patch from mainline
fb68407b0d9efba962c03f55009c797e22f024bc

-aneesh


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
