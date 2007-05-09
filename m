From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: e2fsprogs: Undo I/O manager
Date: Wed,  9 May 2007 13:42:16 +0530
Message-ID: <11786983382211-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:51091 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXEIIM2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 04:12:28 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l498Dvrk8388624
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:13:59 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l498Frep152994
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:15:54 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l498CL2d024834
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 18:12:22 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a very early prototype of what i working on. I have done only minimal
testing of this. To use one need to use the below steps.


       io_manager io_mng = stack_io_manager_init();
       stack_push_io_manager(io_mng, unix_io_manager);
       stack_push_io_manager(io_mng, undo_io_manager);
       flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_RW;
       retval = ext2fs_open2(dev_name,"tdbfilename=/tmp/test.tdb&",
                                       flags, superblock, block_size,
                                       io_mng, &current_fs);

I am sending this across to find out if this is the approach that we want to follow.

-aneesh
