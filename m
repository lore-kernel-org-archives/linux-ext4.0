From: Rishikesh K Rajak <risrajak@in.ibm.com>
Subject: BUG#: extracting the tar file from ext3 to ext4 gives an error
Date: Wed, 13 Aug 2008 14:06:29 +0530
Message-ID: <OF49CDD7DC.5E059142-ON652574A4.002960A6-652574A4.002EF60A@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Rishikesh K Rajak <risrajak@in.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:48987 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753147AbYHMIgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 04:36:37 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7D8aWtW022341
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:06:32 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D8aWAY1163346
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:06:32 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7D8aW3R025513
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:06:32 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi All,

Here is the another bug which i found with ext4 filesystem.

I found this problem with 2.6.27-rc1 kernel.

Here is the bug info link which i have opened with different id:
http://bugzilla.kernel.org/show_bug.cgi?id=11246

Sorry for inconvenience, in description of bug it is mention as Latest
working kernel: 2.6.27-rc1 which should be blank.


Warm Regards

Rishi
Linux Tech Centre
IBM-ISTL, Manyata
Bangalore

