From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: ext4 devel interlock meeting minutes (Sept. 6, 2006)
Date: Wed, 06 Sep 2006 20:39:43 -0500
Message-ID: <1157593183.11909.37.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32936 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1422628AbWIGBjr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Sep 2006 21:39:47 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k871dkft016785
	for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2006 21:39:46 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k871dkei273916
	for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2006 21:39:46 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k871dkS7001042
	for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2006 21:39:46 -0400
Received: from wecm-9-67-122-90.wecm.ibm.com (wecm-9-67-122-90.wecm.ibm.com [9.67.122.90])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k871dj2X001025
	for <linux-ext4@vger.kernel.org>; Wed, 6 Sep 2006 21:39:45 -0400
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Disclaimer:  I didn't take notes during the call and every time I get
back to these minutes, I get interrupted by something else, so forgive
me if I leave anything important out.

- Mingming is working on rebasing the ext4 patches on the -mm tree,
which should closely resemble the ext3 code that will be in the early
2.6.19 code base.

- Shaggy will review all the comments made against Alex Tomas's extents
patches in the ext2-devel list to make sure that they are all addressed
in the latest patches.

- Eric Sandeen reports that Ted Ts'o has picked up about 30% of the 16
TB e2fsprogs patches.

- The -mm kernel contains all the cleanups and 16 TB support that we
want to base ext4 from.  There are a couple outstanding bug fixes that
Badari is working, but they are just a few lines of code.  We expect all
of these patches to make it into 2.6.19-rc1 after 2.6.18 is final.

- Andreas Dilger and Laurent Vivier discussed Bull's large group
descriptor patches.  Patches need more testing.

- Andreas asked about posting minutes.  Shaggy volunteered to do it this
week despite not taking any notes.  :-)  Expect better minutes next
week.

-- 
David Kleikamp
IBM Linux Technology Center

