From: Shen Feng <shen@cn.fujitsu.com>
Subject: git-clone problem
Date: Fri, 13 Jun 2008 15:44:04 +0800
Message-ID: <48522544.50306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYFMHrZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 03:47:25 -0400
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 8B3CD1701C6
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 15:47:23 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id m5D7lMvt016592
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 15:47:22 +0800
Received: from localhost.localdomain (unknown [10.167.141.45])
	by fnst.cn.fujitsu.com (Postfix) with ESMTP id EF350D4092
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 15:49:53 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

When I try to clone the ext4 development tree, I got the following error.
Is there anything wrong?


[fenian@localhost ~]$ git-clone http://www.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
Initialized empty Git repository in /home/fenian/ext4/.git/
Getting alternates list for http://www.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
Also look at http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Getting pack list for http://www.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
Getting index for pack baa9df600683550be458e0a94470c81726b0cf0b
Getting pack baa9df600683550be458e0a94470c81726b0cf0b
 which contains 60badd00b131a5e8db3e765959aed5c41a5796c6
walk 60badd00b131a5e8db3e765959aed5c41a5796c6
walk 7decd67852ad1cdb9fc1ac165d11b69845e9d650
Getting pack list for http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
error: Unable to find 060a71d41ad7ccc3214065a182e6f67568420071 under http://www.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
Cannot obtain needed blob 060a71d41ad7ccc3214065a182e6f67568420071
while processing commit 7decd67852ad1cdb9fc1ac165d11b69845e9d650.

-Shen Feng
