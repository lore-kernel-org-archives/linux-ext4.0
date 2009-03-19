From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Thu, 19 Mar 2009 14:43:06 -0700 (PDT)
Message-ID: <20090319214306.6DE04108041@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757166AbZCSVno (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2009 17:43:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2JLh6Ps026421
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 14:43:42 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #20 from andy-kernelbugzilla@splashground.de  2009-03-19 14:43 -------
Created an attachment (id=20601)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20601&action=view)
Archlinux kernel package diff

A diff between the kernel source packages that introduced the bug and the one
before.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
