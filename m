From: Alex Tomas <bzzz@Sun.COM>
Subject: [RFC] dynamic inodes
Date: Wed, 24 Sep 2008 15:46:56 +0400
Message-ID: <48DA28B0.2020207@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:54189 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXMEl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 08:04:41 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m8OBl5Lp016759
	for <linux-ext4@vger.kernel.org>; Wed, 24 Sep 2008 11:47:07 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K7P00J017APB900@fe-emea-09.sun.com> (original mail from bzzz@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 24 Sep 2008 12:47:05 +0100 (BST)
Received: from gw.home.net ([83.237.175.61])
 by fe-emea-09.sun.com (Sun Java System Messaging Server 6.2-8.04 (built Feb 28
 2007)) with ESMTPSA id <0K7P007Z67EGJFF0@fe-emea-09.sun.com> for
 linux-ext4@vger.kernel.org; Wed, 24 Sep 2008 12:47:05 +0100 (BST)
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.14.2/8.14.2) with ESMTP id m8OBjUdt019459	for
 <linux-ext4@vger.kernel.org>; Wed, 24 Sep 2008 15:45:30 +0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

another idea how to achieve more (dynamic) inodes:
   * new dir_entry format with 64bit inum
   * ino space is 64bit:
     * 2^48 phys. 4K blocks
     * 2^5  inodes in 4K block
     * highest bit is used to choose addressing schema: static or dynamic
   * each block is covered by two bits: in inode (I) and block (B) bitmaps:
     I: 0, B: 0 - block is just free
     I: 0, B: 1 - block is used, but not contains inodes
     I: 1, B: 0 - block is full of inodes
     I: 1, B: 1 - block contains few inodes, has free space

implementation issues:
   * how to allocate new blocks for inodes
     * try to find block with empty inode using bitmaps
     * if we can't find - allocate new block and make it inode block
     * if no free block in this group - repeat 1-2 in another groups
   * how to release block from inodes
     * if block has no used inodes anymore, we mark it 0 in I and 1 in B
     * or if group has very few free inodes, leave it inode block
   * how to find free inode in existing inode block
     * just scan all slots
   * how to migrate/co-exist with static inodes
     * group is marked with DYNAMIC_INODES flag
     * we can turn group to dynamic when it has 0 inodes (simple)
     * we can turn group to dynamic and update bitmaps (hard)
   * how to implement varlen inodes
     * should be simple at allocation time

possibilities:
   * use large inodes to store directory entries
     (4096-128)/(4+8+8) = 198 entries
   * use large inodes to store EAs
   * if we introduce small header for new inode block we could use it to store tails

problems:
   * can't relocate inode w/o changing directory entry
   * can't change inode size after creation
   * e2fsck?

comments/suggestions are very welcome.

thanks, Alex
