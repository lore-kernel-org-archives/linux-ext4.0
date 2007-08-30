From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue rebased to 2.6.rc3-rc4
Date: Wed, 29 Aug 2007 17:59:50 -0700
Message-ID: <1188435590.3799.85.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41253 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbXH3A7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Aug 2007 20:59:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7U0xa9w002396
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 20:59:36 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7U0xahv513668
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 20:59:36 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7U0xZCU013995
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 20:59:35 -0400
Received: from [9.47.17.69] (w-ming-laptop.beaverton.ibm.com [9.47.17.69])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7U0xZnm013969
	for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2007 20:59:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Features in the queue:
  journal checksuming
+ unitialized block group
  new delayed allocation
  multiple block allocation
+ fix mkdir oops with mballoc
+ large block size support for ext2/3/4

http://repo.or.cz/w/ext4-patch-queue.git



Cheers,
Mingming
