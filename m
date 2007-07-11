From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: block reservation patch updated
Date: Wed, 11 Jul 2007 16:24:46 +0530
Message-ID: <1184151287237-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: cmm@us.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58921 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760496AbXGKKzE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 06:55:04 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6BBHhHa224782
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 21:17:43 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6BAwT0e166138
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 20:58:29 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6BAsuHU012054
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jul 2007 20:54:56 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

This is the updated block reservation patch. This patch can replace the
ext4-block-reservation.patch in the patch queue. I think we should
fold all the below patches into one

ext4_block_reservation_fix3.patch
ext4-block-reservation.patch
ext4_rebalance_reservation_invariant_checking_fix.patch
ext4_reserve_global_return_error_fix.patch

If yes i can redo the patch again.

NOTE: The patch follows this mail.
-aneesh
