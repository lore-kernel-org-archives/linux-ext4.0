From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71641] Unreasonable performance degradation in ext4 with full
 data journaling
Date: Wed, 19 Mar 2014 09:35:03 +0000
Message-ID: <bug-71641-13602-EJokyeogGw@https.bugzilla.kernel.org/>
References: <bug-71641-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaCSS25 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 14:28:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8534A203AE
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 09:35:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id EDA6120394
	for <linux-ext4@vger.kernel.org>; Wed, 19 Mar 2014 09:35:03 +0000 (UTC)
In-Reply-To: <bug-71641-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71641

--- Comment #3 from Chia-Hung Chang <fredchang.tc@gmail.com> ---
Test command :  dd if=/dev/zero of=/share/CACHEDEV2_DATA/orderno5G bs=1M
count=5120

The results of block trace can be download as follow.
https://dl.dropboxusercontent.com/u/32959539/blktrace_original_data.7z

The results of btt can be download as follow.
https://dl.dropboxusercontent.com/u/32959539/blktrace_output.7z

There are three folders:
/journal              -->ext4,data=journal              with 375MB/s
/order_delalloc       -->ext4,data=ordered,delalloc     with 937MB/s
/order_nodelalloc     -->ext4,data=ordered,nodelalloc   with 353MB/s


The size of write request with data=ordered,delalloc is 64k mostly.
The size of write requests with data=journal and data=ordered,nodelalloc are 4k
mostly. 

If we observe the average Q2Q in btt results, which means time interval between
requests, we have

/journal           0.00081
/order_nodelalloc  0.00031

It seems to be the reason of performance degradation.
Is any one know why the time interval of requests is significantly longer with
data=journal?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
