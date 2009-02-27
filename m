From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Fri, 27 Feb 2009 09:13:48 -0800 (PST)
Message-ID: <20090227171349.018E611D108@picon.linux-foundation.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbZB0ROW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 12:14:22 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RHDn4i018825
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 09:13:50 -0800
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787





------- Comment #1 from marko.kohtala@gmail.com  2009-02-27 09:13 -------
Created an attachment (id=20381)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20381&action=view)
Kernel config


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
