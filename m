From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC] truncate_mutex read write semaphore conversion
Date: Mon,  3 Dec 2007 15:55:54 +0530
Message-ID: <1196677557-10403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46511 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbXLCK0K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 05:26:10 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id lB3APvst025546
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:57 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3APvUv2814026
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:55:57 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id lB3APvYG029951
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 10:25:57 GMT
Received: from localhost.localdomain (skywalker.in.ibm.com [9.124.35.24])
	by d28av04.in.ibm.com (8.13.1/8.12.11) with ESMTP id lB3APvlR029948
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 10:25:57 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The below patchset is NOT for patch queue. I am posting it here to get
feedback regarding the approach and what test I need to run to make sure we
are not breaking any locking rules.

I have run dbench, ffsb, fsstress, fs_di, fs_inode, fsx_linux . Bonnie
didn't run completely. In the automated setup i had it didn't save any
logs to find out what went wrong. I will be looking into this
