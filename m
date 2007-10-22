From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 2 00/14][e2fsprogs] Uninit block group break down
Date: Sun, 21 Oct 2007 21:03:08 -0500
Message-ID: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34525 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXJVCGf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:06:35 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9M26YYJ019735
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 22:06:34 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M26Ycb116782
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:34 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M26X6g007592
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:34 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M26XPJ007586
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:33 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The Uninit block group patch is painful to review since it's quite a
large patch.  Since simple patches are easier to review, I decided to
break down the patch into smaller logical pieces that should be easier
to review, clean and fix.
 
Aside from the breakdown, this is essentially the same patch that
Avantika submitted to the mailing list a couple of weeks ago with some
minor changer to allow it to apply on the latest git tree.  

Tested on PPC64 with 2.6.23-rc9 + ext4 patch queue.

Changes from the last series:

- Changed file ordering under $(OBJS) and $(SRCS)
- Fix typos to make it work under PPC64
- Added Andreas fixes for PowerPC.
	http://lists.openwall.net/linux-ext4/2007/06/05/31
- Use ext2fs/ext2_types.h instead of linux/types.h

-JRS
