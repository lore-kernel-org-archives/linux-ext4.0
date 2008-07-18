From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: e2fsprogs and blocks outside i_size
Date: Fri, 18 Jul 2008 17:41:30 +0530
Message-ID: <20080718121130.GB23898@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40241 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755409AbYGRMLi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 08:11:38 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6ICBYK6028641
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:41:34 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6ICBY5Y1126592
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:41:34 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6ICBYUH009134
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 17:41:34 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

With fallocate FALLOC_FL_KEEP_SIZE option, when we write to prealloc
space and if we hit ENOSPC when trying to insert the extent,
we actually zero out the extent. That means we can have blocks
outside i_size for an inode. I guess e2fsck currently doesn't
handle this. Or should we fix kernel to update i_size to the
right value if we do a zero out of the extent ?

With fallocate if the prealloc area is small we also aggressively zeroout.
This was needed so that a random write pattern on falloc area doesn't
results in too many extents.  That also can result in the above
error on fsck.

-aneesh
