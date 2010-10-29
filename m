From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Fri, 29 Oct 2010 21:46:39 GMT
Message-ID: <201010292146.o9TLkd9Y017608@demeter2.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:60106 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab0J2Vqk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Oct 2010 17:46:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9TLkdoA017609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 29 Oct 2010 21:46:39 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #12 from Martin Moerch <martinmoerch@gmail.com>  2010-10-29 21:46:35 ---
I remember first noticing it as far back as when 8.04 came out, and has
happened ever since. However, around that time, my LVM grew substantially
aswell for the next year. So if it's 8.04 and up, or if it's the size of the
LVM as it gets larger, I don't know.

By "first write" I mean the first write after a reboot. As soon as the system
wants to flush data to the drives, it starts this cycle of slow and cumbersome
I/O waiting.

I'm using the mount options as per the tune2fs attachment further up.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
