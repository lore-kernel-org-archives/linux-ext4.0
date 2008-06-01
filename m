From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 0/6] delayed allocation ENOSPC handling
Date: Sun, 01 Jun 2008 16:35:17 -0700
Message-ID: <1212363317.4368.63.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45191 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756627AbYFAXfb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 19:35:31 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51NZMAd003789
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:22 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51NZMl9163188
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:22 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51NZMZB031198
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:22 -0400
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51NZL1Y031180
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following series patches does block reservation for delayed
allocation, to avoid ENOSPC later at page flush time.

Blocks(data and metadata) are reserved at da_write_begin()
time, the freeblocks counter is updated by then, and the number of
reserved blocks is store in per inode counter.
        
At the writepage time, the unused reserved meta blocks are returned
back. At unlink/truncate time, reserved blocks are properly released.


Signed-off-by: Mingming cao <cmm@us.ibm.com>


