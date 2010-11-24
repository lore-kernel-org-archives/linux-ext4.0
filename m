From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20902] High IO wait when writing to ext4
Date: Wed, 24 Nov 2010 05:13:22 GMT
Message-ID: <201011240513.oAO5DMoG002507@demeter1.kernel.org>
References: <bug-20902-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:53025 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0KXFNZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Nov 2010 00:13:25 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAO5DNC6002508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 24 Nov 2010 05:13:23 GMT
In-Reply-To: <bug-20902-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=20902





--- Comment #17 from Eric Sandeen <sandeen@redhat.com>  2010-11-24 05:13:16 ---
Created an attachment (id=38012)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=38012)
graph of IO

Here's a graph of the IO.

Does the trace cover the entire test starting at mount?  Looks like it.

Were the 10x128MB writes in series or parallel?

Looks like it spends about 20s seekily sucking up 28MB of metadata off the disk
(mostly done in the [flush-253:0] process) and then doing 1.3G of horrible
writeback ;)

What exact commands did you use for the test; I assume it was buffered IO, all
in the same subdir?  Sync afterwards or not?

It might be interesting to see the tune2fs -l output to correlate the initial
reads to disk metadata but I suppose we can have a pretty good guess at that.

Anyway looks like the first issue is the giant seeky read of disk metadata
before any writing even gets underway.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
