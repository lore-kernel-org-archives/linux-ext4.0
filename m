From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 14:41:54 +0530
Message-ID: <46F8D0DA.7090500@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:50133 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbXIYJMt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:12:49 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P9CWhG006493
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:12:32 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P9CVTj1249310
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:12:31 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P9CAS9030516
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:12:15 +1000
In-Reply-To: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas,

The patches are on top of patch queue. I haven't touched
the uid and gid of ext4_inode. Do you think i should
change that too ?

7/7 is not the part of the series. But it is important.
Should i send it as a separate patch for the 2.6.24 ?

-aneesh
