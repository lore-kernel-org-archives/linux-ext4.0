From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: block groups with no inode tables
Date: Tue, 10 Jul 2007 12:12:21 -0500
Message-ID: <20070710121221.5478a1e3@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51357 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbXGJRQh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 13:16:37 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AHGbYT014907
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:16:37 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AHGaLl552886
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:16:36 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AHGaF8018102
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:16:36 -0400
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l6AHGaBR018084
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 13:16:36 -0400
Received: from rx8 (rx8.austin.ibm.com [9.41.41.30])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l6AHGaEq031030
	for <linux-ext4@vger.kernel.org>; Tue, 10 Jul 2007 12:16:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi folks,

As I play with the allocation of the metadata for the FLEX_BG feature,
it seems that we could benefit from having block groups with no inode
tables.  Right now we allocate one inode table per bg base on the
inode_blocks_per_group.  For FLEX_BG though, it would make more sense
to have a larger inode tables that fully use the inode bitmap allocated
on the first few block groups.  Once we reach the number of inode per
FLEX_BG, then the remaining block groups could then have no inode
tables defined.

The idea here is that we better utilize the inode bitmaps and reduce the
number of inode tables to improve mkfs/fsck times. We could also
support expansion of inode since we have block groups that have empty
entries in the block group descriptors and as long as we can find
enough empty blocks for the inode table expanding the number of inodes
should be relatively easy.

Don't know if ext4 currently supports this.  Any thoughts?

-JRS
