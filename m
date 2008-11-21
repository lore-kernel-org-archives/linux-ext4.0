From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: patchqueue update
Date: Fri, 21 Nov 2008 22:18:29 +0530
Message-ID: <20081121164829.GE11212@skywalker>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:53434 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYKUQsh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 11:48:37 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id mALGmZO9010868
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:18:35 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALGma1f4497616
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:18:36 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id mALGmYpb010722
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 03:48:35 +1100
Content-Disposition: inline
In-Reply-To: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Along with this change you can drop the patch
aneesh-8-fix-double-free-of-blocks from the patchqueue.
The changes are not needed. We were finding double free
due to a race in uninit bg code which i am fixing in 
series sent after this mail.

-aneesh
