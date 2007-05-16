From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue git updated to 2.6.22-rc1
Date: Wed, 16 May 2007 16:49:17 -0700
Message-ID: <1179359357.3771.19.camel@dyn9047017103.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:39788 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763221AbXEPXtX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 May 2007 19:49:23 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4GNjgPC006710
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2007 19:45:42 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4GNnJvX105974
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2007 17:49:19 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4GNnJFp021364
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2007 17:49:19 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

I just updated the ext4 patch queue, rebase to 2.6.22-rc1.

changes since 2.6.21.1
#Updated with Amit's latest fallocate() patches posted yesterday.
fallocate-1-fallocate-syscall
fallocate-1b-fallocate_inode_op_fix.patch
fallocate-2-fallocate-syscall-s390
fallocate-2b-fallocate-syscall-ia64
fallocate-3-extent-overlap-bugfix
fallocate-4-ext4-fallocate_and_unitialized_extents
fallocate-5-ext4-uninit-extents

#Added a patch to fix return value of fallocate() inode operation;
fallocate-1b-fallocate_inode_op_fix.patch

#Added a patch to enable extents mount option by default;
ext4_extents_on_by_default.patch

#Added a patch to fix compile error with expand inode extra_isize;
ext4_expand_inode_isize_fix.patch

#Added patch to remove unnecessary exported ext4 symbols;
ext4_remove_exported_symbles.patch

Tested this series on x86,x86_64,ppc64 with fsx, dbench and tiobench

http://repo.or.cz/w/ext4-patch-queue.git

Mingming
