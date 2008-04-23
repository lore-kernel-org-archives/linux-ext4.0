From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Fix in the flex_bg inode allocator.
Date: Wed, 23 Apr 2008 12:17:45 -0500
Message-ID: <20080423171522.8494.21796.stgit@freedom>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52980 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYDWRRv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 13:17:51 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NHHpSA029937
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 13:17:51 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NHHo5K215546
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:50 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NHHokB007614
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:50 -0600
Received: from [127.0.0.1] (freedom.ltc.austin.ibm.com [9.3.191.6])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3NHHo8Y007607
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 11:17:50 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Notice that the patch in the patch queue did not update flex group
stats when using mballoc causing the allocator to behave stangely.

Mingming - please update the patch queue with the new patch 
---

Jose R. Santos (1):
      commit e8fa6c1ac978815e421c296673ff34776551f4b9


 fs/ext4/balloc.c  |   16 +++++++++
 fs/ext4/ext4.h    |   25 +++++++++++++-
 fs/ext4/ext4_sb.h |    3 ++
 fs/ext4/ialloc.c  |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/mballoc.c |   14 ++++++++
 fs/ext4/super.c   |   57 +++++++++++++++++++++++++++++++
 6 files changed, 210 insertions(+), 1 deletions(-)

-- 


-JRS
