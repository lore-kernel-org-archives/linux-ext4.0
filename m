From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 0/4][e2fsprogs] Enable FLEX_BG support
Date: Mon, 13 Aug 2007 23:32:45 -0500
Message-ID: <20070814043245.32206.34785.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44814 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbXHNEcz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2007 00:32:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7E4YDaE023828
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:34:13 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7E4WsGq534760
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:32:54 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7E4WstF018858
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:32:54 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l7E4WrSu018848
	for <linux-ext4@vger.kernel.org>; Tue, 14 Aug 2007 00:32:54 -0400
Received: from [127.0.1.1] (sig-9-65-58-9.mts.ibm.com [9.65.58.9])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l7E4WrnL040298
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 23:32:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The following series of patches add support creating and checking
filesystems with the FLEX_BG feature.  This feature currently groups
meta-data from a series of groups at the beginning of a flex group in
order to improve performance during heavy meta-data operations.

Changes from last time:
- When making a filesystem with FLEX_BG also enable META_BG feature.
- Allocate meta data within the META_BG group range.  
- Descriptor checking ensures bitmaps and inode tables are in the META 
  group.

Problems and TODOs:
- Fsck has some failures using FLEX_BG and resize_inode features at the
  same time.  Still investigating.
- Need to define how unallocated inode tables will look like.
- Need to create test case

-JRS
