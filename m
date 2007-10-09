From: markn@au1.ibm.com
Subject: [patch 0/2] ext4 fixups for 2.6.23-rc8-mm2/ext4 git tree
Date: Tue, 09 Oct 2007 15:50:33 +1000
Message-ID: <20071009055033.145153755@au1.ibm.com>
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47530 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbXJIGNV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 02:13:21 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l996DKCM018744
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:13:20 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l996C4SV479282
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:12:04 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9969BJR015972
	for <linux-ext4@vger.kernel.org>; Tue, 9 Oct 2007 16:09:11 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-- 
I've been maintaining a containers patchset that sits on top of the -mm tree and in testing the patches I maintain, I've found a bug in the ext4 code in 2.6.23-rc8-mm2 that causes the following build error:

linux/fs/ext4/mballoc.c: In function 'init_ext4_proc':
linux/fs/ext4/mballoc.c:2923: error: 'proc_root_fs' undeclared (first use in this function)
linux/fs/ext4/mballoc.c:2923: error: (Each undeclared identifier is reported only once
linux/fs/ext4/mballoc.c:2923: error: for each function it appears in.)

This same build error occurs in the ext4 git tree and so the patch that addresses this is the first patch.

The second patch addresses a problem that commit bfbca121e6ffc9f97439d541bf1a847accb3aed4 (mballoc core patch) introduced, whereby the added call to init_ext4_proc() means that init_ext4_fs() doesn't fully clean up after itself on fail.

These patches were originally for 2.6.23-rc8-mm2 but I've refreshed them so they apply cleanly to the ext4 git tree (refreshed just because lines were offset).

Hopefully these patches help.

Thanks,
Mark Nelson.
