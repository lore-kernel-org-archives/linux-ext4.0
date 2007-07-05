From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH]mballoc rebased on top of ext4-patch-queue.
Date: Thu,  5 Jul 2007 23:33:19 +0530
Message-ID: <1183658603788-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:32894 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbXGESEU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:04:20 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l65IQOM7268556
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:26:37 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65I75dC197520
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:07:06 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65I3XS8013242
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jul 2007 04:03:33 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The patch set is forward port of the changes found at

ftp://ftp.clusterfs.com/pub/people/alex/2.6.19-rc6/

on top of 2.6.22-rc6 (ext4-patch-queue)

Only visible change i made is to enabled MBALLOC option default so that we
get wider testing.

Test booted and did minimal testing on ext4 files system via Qemu.
