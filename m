From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: e2fsprogs: Undo I/O Manager and large inode migration support in tune2fs
Date: Wed, 25 Jul 2007 11:06:25 +0530
Message-ID: <11853417881304-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:49398 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbXGYFgn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2007 01:36:43 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6P602cC255200
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 16:00:02 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6P5e8xw207094
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 15:40:08 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6P5aZfh013261
	for <linux-ext4@vger.kernel.org>; Wed, 25 Jul 2007 15:36:35 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi Ted,

The series is on top of

f1f115a78f5ea599fc5f8815a741d43fedd5840d

Changes from last post include

a) Add O_EXCL flag to tdb_open.
b) Fix the return value when we fail to create the tdb file
c) Add tune2fs -I <new_inode_size> for migrating to large inode size.
