From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Fri, 28 Mar 2014 10:55:10 +0000
Message-ID: <bug-71641-13602-gpFTFnckuy@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34209 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaC1KzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2014 06:55:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7143320123
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2014 10:55:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 27EFE202A7
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2014 10:55:11 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #10 from Chia-Hung Chang <fredchang.tc@gmail.com> ---
BTW, if we use 1G ramdisk as journal area, the performance with JBD2_NR_batch
=2048 can be 571MB/s

Please download the result of blktrace as following,
https://dl.dropboxusercontent.com/u/32959539/JBD2_NR_batch_2048_1M.7z

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
