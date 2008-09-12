From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Update for patches in patch queue
Date: Fri, 12 Sep 2008 14:32:26 +0530
Message-ID: <1221210148-26329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53758 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbYILJDf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:03:35 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m8C93Uo5000753
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C930TW1470594
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 14:33:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m8C92xFQ002265
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:03:00 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches update the below patches in the patch queue.

ext4_truncate_block_allocated_on_a_failed_ext4_write_begin.patch
ext4_i_disksize_lock_race_fix.patch

The change is to move some parts of the patch from ext4_i_disksize_lock_race_fix.patch
to ext4_truncate_block_allocated_on_a_failed_ext4_write_begin.patch


