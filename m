From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 00/13][e2fsprogs] Uninit block group break down
Date: Thu, 11 Oct 2007 14:15:59 -0500
Message-ID: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60078 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbXJKTQL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Oct 2007 15:16:11 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJG6KZ001443
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:06 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJG6C4124578
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:06 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJFtS4028085
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:15:55 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJFtXq027374
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:15:55 -0400
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJFie6035100
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:15:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The Uninit block group patch is painful to review since it's quite a
large patch.  Since simple patches are easier to review, I decided to
break down the patch into smaller logical pieces that should be easier
to review, clean and fix.
 
The patch is based from the latest e2fsprogs git tree and aside from a
compile test (which fails on PPC64 because of missing
ext2fs_swab_group_desc()), I have not fully tested these patches.  My
intent here is to get some of the back log of patches in better shape
for eventual inclussion into Ted's tree.

Aside from the breakdown, this is essentially the same patch that
Avantika submitted to the mailing list a couple of weeks ago with some
minor changer to allow it to apply on the latest git tree.  Let me
know what you folks think.
 
-JRS
