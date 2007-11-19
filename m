From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [Take 2] ext2/3/4 block bitmap validation patches
Date: Mon, 19 Nov 2007 20:25:57 +0530
Message-ID: <1195484161-14472-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: cmm@us.ibm.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41108 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbXKSO42 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2007 09:56:28 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAJEulQ8004633
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:47 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAJEuQJJ2342964
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:26 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAJEu8Za006682
	for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2007 01:56:08 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This is the updated ext2/3/4 block bitmap validation patches

Changes from the last post

a) moved the bh_uptodate_or_lock and bh_submit_read to
  fs/buffer.c and added EXPORT_SYMBOL

b) Updated bh_submit_read not to release buffer on
   failure. This handles one reference handling bug in the
   error patch.
