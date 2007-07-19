From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [Take 2]e2fsprogs: Undo I/O manager
Date: Thu, 19 Jul 2007 23:28:06 +0530
Message-ID: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:57985 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939262AbXGSR6R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2007 13:58:17 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6JHxPSQ3416106
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 03:59:25 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6JI1jW3196112
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 04:01:45 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6JHwC8e019492
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 03:58:12 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch fixes some bugs found during testing of the large
inode migration patches.

-aneesh
