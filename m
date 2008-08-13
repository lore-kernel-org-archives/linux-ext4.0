From: Rishikesh K Rajak <risrajak@in.ibm.com>
Subject: BUG: Reducing the lvm partition on ext4 filesystem " ( 2.6.27-rc1 )
Date: Wed, 13 Aug 2008 13:01:38 +0530
Message-ID: <OF80EF388C.3D9E8928-ON652574A4.0028C9C8-652574A4.0029043A@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Rishikesh K Rajak <risrajak@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:50282 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751954AbYHMHbw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 03:31:52 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7D7VgEW016729
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 13:01:42 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D7VgNe1228940
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 13:01:42 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7D7Vggd022192
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 13:01:42 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi All,

I have created the lvm partition on my machine and found there is some
problem with reducing the size with resize2fs tool  on 2.6.27-rc1 kernel.

I am not sure this is an exact bug of ext4 filesystem or there is some
problem with e2fsprogs/resize2fs tool.

here is the bug link which i raised :
http://bugzilla.kernel.org/show_bug.cgi?id=11317

Warm Regards

Rishi
Linux Tech Centre
IBM-ISTL, Manyata
Bangalore

