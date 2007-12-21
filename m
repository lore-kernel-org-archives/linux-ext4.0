From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 11s! [fsstress:5534]
Date: Fri, 21 Dec 2007 16:28:56 +0530
Message-ID: <20071221105856.GA6989@skywalker>
References: <20071220143242.GB6953@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Alex Tomas <bzzz@sun.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56161 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751971AbXLUK7L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2007 05:59:11 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id lBLAwxuB018441
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 16:28:59 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBLAwwZW622816
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 16:28:59 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id lBLAwxDf010623
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 10:58:59 GMT
Content-Disposition: inline
In-Reply-To: <20071220143242.GB6953@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 20, 2007 at 08:02:42PM +0530, Aneesh Kumar K.V wrote:
> I am seeing this with the patch queue. I can reproduce this on x86 and
> powerpc. I see the file system full when this happens. The same happens even
> without delalloc enabled.
> 
> 


The below patch fix the same for me. One thing i observed with the patch queue
is, enabling delalloc by default. Delalloc doesn't handle the file system full
case because there is no block reservation. Unless we have block reservation i
guess we should disable delalloc by default.

I will send a full patch with proper log message.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 72e1920..8b45ac0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3791,6 +3791,7 @@ repeat:
 	/* if we still need more blocks and some PAs were used, try again */
 	if (free < needed && busy) {
 		ext4_unlock_group(sb, group);
+		schedule_timeout(HZ);
 		goto repeat;
 	}
 
