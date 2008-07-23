From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patches for patchqueue
Date: Wed, 23 Jul 2008 22:40:44 +0530
Message-ID: <1216833047-4959-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:58243 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753350AbYGWRLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 13:11:06 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6NHAuM2019103
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:40:56 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6NHAtqB1659062
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:40:55 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6NHAtqv027776
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:40:55 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sending below patch for the patchqueue.

ext4-Improve-error-handling-in-mballoc.patch
ext4-Convert-the-usage-of-NR_CPUS-to-nr_cpu_ids.patch
ext4-Don-t-allow-lg-prealloc-list-to-be-grow-large.patch

I have updated the last  patch to simplify locking.

-aneesh


