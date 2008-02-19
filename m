From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Error with the latest stable series of the patch queue.
Date: Tue, 19 Feb 2008 20:51:36 +0530
Message-ID: <20080219152136.GA7177@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:56832 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbYBSPVj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 10:21:39 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1JFLaiw028883
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 20:51:36 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JFLaM31147100
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 20:51:36 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1JFLah4001947
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 15:21:36 GMT
Received: from skywalker ([9.124.217.193])
	by d28av03.in.ibm.com (8.13.1/8.12.11) with ESMTP id m1JFLZXp001936
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 15:21:36 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I am seeing the below error in the console. But the tests are reported
as success.

EXT4-fs: mballoc enabled
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204044: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204045: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204047: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204056: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204061: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204065: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204068: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204069: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204071: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
EXT4-fs error (device sda7): ext4_ext_find_extent: bad header in inode
#204077: invalid magic - 


-aneesh
