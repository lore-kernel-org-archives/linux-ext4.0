From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 00/12] e4defrag: fragmentation score rework and cleanups
Date: Wed, 17 Aug 2011 16:46:34 +0900
Message-ID: <4E4B71DA.2000909@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:42889 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HQIKc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:10:32 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p7H8ATFn021245
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 17:10:29 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch set adds the new function e2p_get_fragscore() to libe2p, that
calculates the fragmentation score. Fragmentation score shows how badly
fragmented the file might be. e4defrag uses it to determine smarter whether to
call EXT4_IOC_MOVE_EXT ioctl.

In addition, the 6th to the last is bugfix or cleanup patch.

v1 -> v2
- Fix the method of calculating fragmentation score to show the number of
  extents per specified blocks
- Remove the check of filesystem type to calculate the fragmentation score
  for the file in non-ext4 filesystem
- Drop the patch for filefrag
- Fix free blocks check to use reserved blocks by users specified by
  resuid/resgid mount option
- Add -F option to defrag a file if the fragment can get better even if
  the fragmentation score of donor file is bigger than 1

This patch set is for e2fsprogs git tree. (commit:d4c0d8e5b8)

Kazuya Mio (12):
  libe2p: Add new function e2p_get_fragscore()
  e4defrag: Remove -c option which checks the file fragmentation
  e4defrag: Remove old fragmentation score calculation code
  e4defrag: Use e2p_get_fragscore() for decision of whether to defrag
  e4defrag: Add -F option for force defrag
  e4defrag: Allow user who has read+write permission to defrag
  e4defrag: Allow user who can use reserved blocks to defrag
  e4defrag: Fix memory leak in file_defrag()
  e4defrag: Use blk64_t instead of ext4_fsblk_t
  e4defrag: Use EXT2_SUPER_MAGIC instead of EXT4_SUPER_MAGIC
  e4defrag: Fix error messages more clearly
  e4defrag: Remove unnecessary code

 lib/e2p/Makefile.in      |    6 
 lib/e2p/e2p.h            |    3 
 lib/e2p/fragment_score.c |  132 ++++++
 misc/Makefile.in         |    4 
 misc/e4defrag.8.in       |   33 -
 misc/e4defrag.c          |  923 +++++------------------------------------------
 6 files changed, 262 insertions(+), 839 deletions(-)

Regards,
Kazuya Mio
