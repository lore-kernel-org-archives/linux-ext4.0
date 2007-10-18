From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: patch queue updates
Date: Thu, 18 Oct 2007 15:53:21 +0530
Message-ID: <47173419.7060000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51038 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbXJRKZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2007 06:25:19 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9IAP9XB005923
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:25:09 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9IANtYV970988
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:23:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9IANcQ9017850
	for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2007 20:23:39 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

The patch queue updated on top of d85714d81cc0408daddb68c10f7fd69eafe7c213

The commit d85714d81cc0408daddb68c10f7fd69eafe7c213  contain changes that
Andrew pushed to linus which had conflicts with patches in the patch queue.
The update fixes them. 

Changes
a) ext4_grpnum_t.patch got updated to take care of conflicts.
b) The ext4-cleanup.patch is split into 4 small patches.
  ext4-cleanup.patch
  ext4-cleanup-2.patch
  ext4-cleanup-3.patch
  ext4-cleanup-4.patch

c) mballoc-core.patch updated to fix compile error. 

The series can be found at

http://www.radian.org/~kvaneesh/ext4/oct-18-2007/
http://www.radian.org/~kvaneesh/ext4/oct-18-2007/patch-series.tar


-aneesh
