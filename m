From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Fri, 16 Jan 2009 13:24:12 -0800 (PST)
Message-ID: <20090116212412.4B32B108043@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760449AbZAPVYn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 16:24:43 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0GLOCTC005705
	for <linux-ext4@vger.kernel.org>; Fri, 16 Jan 2009 13:24:13 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #11 from folkert@vanheusden.com  2009-01-16 13:24 -------
Cannot reproduce the problem anymore with 2.6.26 but very easy for 2.6.27 and
2.6.28.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
