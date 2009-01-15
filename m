From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Thu, 15 Jan 2009 07:48:14 -0800 (PST)
Message-ID: <20090115154814.BE6EF11D108@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754243AbZAOPsR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jan 2009 10:48:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0FFmEAF005110
	for <linux-ext4@vger.kernel.org>; Thu, 15 Jan 2009 07:48:15 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #19 from csights@fastmail.fm  2009-01-15 07:48 -------
http://bugzilla.kernel.org/show_bug.cgi?id=12224

> ------- Comment #17 from sandeen@redhat.com  2009-01-14 14:58 -------
> Created an attachment (id=19805)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19805&action=view)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=19805&action=view)
> patch reverting old change & adding Jan's proposed fix

Does this patch "revert the old change"?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
