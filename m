From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Creating a >32bit blocks filesystem.
Date: Thu, 3 May 2007 14:08:04 -0500
Message-ID: <20070503140804.463b20e1@naruto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59178 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbXECTIH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 May 2007 15:08:07 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l43J87CS012540
	for <linux-ext4@vger.kernel.org>; Thu, 3 May 2007 15:08:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l43J87iG386724
	for <linux-ext4@vger.kernel.org>; Thu, 3 May 2007 15:08:07 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l43J86p3005410
	for <linux-ext4@vger.kernel.org>; Thu, 3 May 2007 15:08:06 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l43J86gG005387
	for <linux-ext4@vger.kernel.org>; Thu, 3 May 2007 15:08:06 -0400
Received: from naruto (sig-9-49-128-71.mts.ibm.com [9.49.128.71])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l43J85nW042616
	for <linux-ext4@vger.kernel.org>; Thu, 3 May 2007 14:08:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks,

I've been trying test a patch to set JBD2_FEATURE_INCOMPAT_64BIT, but
I'm stuck just trying to test the patch since there doesn't seem to be
a way to create a ext4 filesystem that has more than 32bit blocks.  It
seems like e2fsprogs + Ted's patches don't support greater that 32bit
block numbers while the the e2fsprogs 64bit patches from BULL create
the filesystem but the kernel seems unable to mount.

Am I missing something?

-JRS
