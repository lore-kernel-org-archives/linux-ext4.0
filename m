From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12686] kernel oops __ticket_spin_lock
Date: Wed, 11 Feb 2009 02:55:41 -0800 (PST)
Message-ID: <20090211105541.D8C37108040@picon.linux-foundation.org>
References: <bug-12686-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbZBKKzn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 05:55:43 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1BAtfhY006499
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 02:55:42 -0800
In-Reply-To: <bug-12686-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12686





------- Comment #2 from dmaciejak@fortinet.com  2009-02-11 02:55 -------
Created an attachment (id=20190)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20190&action=view)
gzip ext4 poc


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
