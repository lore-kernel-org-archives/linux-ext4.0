From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: ext4 errors while runing fsx (2.6.25)
Date: Mon, 21 Apr 2008 17:18:53 -0700
Message-ID: <1208823533.17986.48.camel@badari-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44040 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758657AbYDVAS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 20:18:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3M0IwtR022439
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 20:18:58 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3M0IvHn240042
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 20:18:57 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3M0Iqfp006775
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 20:18:52 -0400
Received: from [9.47.17.100] (badari-desktop.beaverton.ibm.com [9.47.17.100])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3M0Ipg0006659
	for <linux-ext4@vger.kernel.org>; Mon, 21 Apr 2008 20:18:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Got these messages while running fsx on ext4.
Known issue ?

Thanks,
Badari

EXT4 FS on hda1, internal journal
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
pa ffff8101cc8400b0: logic 8, phys. 9065, len 56
EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 37, pa_free 38

pa ffff8101cc8556b0: logic 32, phys. 8935, len 32
EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 21, pa_free 22

pa ffff8101cc85e8b0: logic 9, phys. 8971, len 55
EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 43, pa_free 44

pa ffff81017d0f7330: logic 39, phys. 9131, len 25
EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 20, pa_free 21

pa ffff8101bb1431b0: logic 18, phys. 33438, len 46
EXT4-fs error (device hda1): ext4_mb_release_inode_pa: free 26, pa_free 27


