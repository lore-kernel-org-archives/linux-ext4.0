From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: (un)lock_kernel() ?
Date: Wed, 4 Apr 2007 08:57:38 -0400 (EDT)
Message-ID: <alpine.DEB.0.83.0704040853450.28216@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hammerhead.shentel.net ([204.111.1.228]:46907 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333AbXDDM5k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 08:57:40 -0400
Received: from sigma.j-a-k-j.com (jakj@n152s125.ntc.blacksburg.shentel.net [204.111.152.125])
	by hammerhead.shentel.net (8.13.8/8.13.8) with ESMTP id l34Cvc3E022805
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 08:57:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Why does ext4_fill_super release the BKL on entry and take it on both 
normal and abnormal exit? As far as I can see, ext4_fill_super is called 
by get_sb_bdev, which calls the ->get_sb method without the BKL, and 
ext4_get_sb calls get_sb_bdev without the BKL. And the ext2 code does not 
touch the BKL in ext2_fill_super.

Is the VFS code going to be changed somewhere in the future and it's being 
anticipated, or is this a bug?
