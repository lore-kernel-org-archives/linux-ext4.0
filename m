From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Wed, 30 May 2012 21:20:32 +0000 (UTC)
Message-ID: <20120530212032.6DEE811FD1B@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53061 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2E3VUf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 May 2012 17:20:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B56DE2041C
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 21:20:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 79A2320430
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2012 21:20:32 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #9 from Florian Pritz <flo@xssn.at>  2012-05-30 21:20:32 ---
Created an attachment (id=73471)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=73471)
blktrace files

I'm running 2 raid 1 arrays with 2 and 3 disks, both in a single LVM volume
group which contains one big LV (dm-2). 

I've started blktrace before the lockup happened and killed it a few seconds
after with ^C. I can also let it run until nfsd gives up, if you want that.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
