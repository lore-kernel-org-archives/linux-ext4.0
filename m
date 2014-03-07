From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 07 Mar 2014 17:57:32 +0000
Message-ID: <bug-71641-13602-wlWuvG8NpE@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52850 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaCGR5f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 12:57:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E2F9B202F2
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 17:57:33 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 01DF3202EA
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 17:57:33 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #2 from Chia-Hung Chang <fredchang.tc@gmail.com> ---

> 
> How big was the ramdisk?  Since all of the blocks are going through
> the journal, even if it is on the journal, it requires more commits
> and thus more checkpoint operations, which means more updates to the
> disk.  A bigger journal will help minimize this issue.
> 
> Would you be willing to grab block traces for both the disk and the
> external journal device?
> 
> I will add that the workload of "dd if=/dev/zero of=file" is probably
> the worst case for data=journal, and if that's really what you are
> doing, it's a case of "doctor, doctor, it hurts when I do that".  All
> file systems modes will have strengths and weaknesses, and your use
> case one where I would simply tell people, "don't use that mode".
> 
> If you want to work on improving it, that's great.  Gather data, and
> if we can figure out an easy way to improve things, great.  But I'll
> warn you ahead of time this is not necessarily something I view as
> "unreasonable", nor is it something that I would consider a high
> priority thing to fix.
> 
                      - Ted
I use two sizes of ramdisk, 128MB and 1024MB. With 1024MB journal area, the
performance is slight improved. But performance degradation is still
significant. 

I am willing to grab block traces. Please tell me how to get the traces you
want.

As you can see that the performance degradation of applying data=journal in
raid5 is 80%, which makes it hard to use. If I know where the problem is, I
will try to improve it.

Thanks for your help.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
