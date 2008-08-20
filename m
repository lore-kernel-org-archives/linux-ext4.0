From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ENOSPC returned during writepages
Date: Wed, 20 Aug 2008 11:13:39 +0530
Message-ID: <20080820054339.GB6381@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:51706 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1749667AbYHTFnr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 01:43:47 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7K5hiD7023849
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:13:44 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7K5hirr1700086
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:13:44 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7K5hisI014445
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:13:44 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am getting this even with the latest patch queue. The test program is
a modified fsstress with fallocate support.

mpage_da_map_blocks block allocation failed for inode 377954 at logical
offset 313 with max blocks 4 with error -28
mpage_da_map_blocks block allocation failed for inode 336367 at logical
offset 74 with max blocks 9 with error -28
mpage_da_map_blocks block allocation failed for inode 345560 at logical
offset 542 with max blocks 7 with error -28
This should not happen.!! Data will be lost
mpage_da_map_blocks block allocation failed for inode 355317 at logical
offset 152 with max blocks 10 with error -28
This should not happen.!! Data will be lost
mpage_da_map_blocks block allocation failed for inode 395261 at logical
offset 462 with max blocks 1 with error -28
This should not happen.!! Data will be lost
mpage_da_map_blocks block allocation failed for inode 323784 at logical
offset 313 with max blocks 11 with error -28
This should not happen.!! Data will be lost

