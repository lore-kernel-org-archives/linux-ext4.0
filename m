From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 00/11] e4defrag: fragmentation score rework and cleanups
Date: Fri, 08 Apr 2011 16:50:54 +0900
Message-ID: <4D9EBE5E.3060102@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38481 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1DHIGR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:06:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch set adds the new function get_fragment_score() to libe2p, that
calculates the fragmentation score. Fragmentation score shows how badly
fragmented the file might be. filefrag uses it to make a user understand
the status of the file fragmentation easily. And e4defrag also uses it
to determine smarter whether to call EXT4_IOC_MOVE_EXT ioctl. This improvement
is based on the following Ted's idea.
http://marc.info/?l=linux-ext4&m=129324612305011&w=4

In addition, the 6th to the last is bugfix or cleanup patch.

This patch set is for e2fsprogs git tree. (commit:5af9eeaa7d)

Kazuya Mio (11):
  libe2p: Add new function get_fragment_score()
  filefrag: Output fragmentation score
  e4defrag: Remove -c option which check the file fragments
  e4defrag: Remove old fragmentation score calculation code
  e4defrag: Use get_fragment_score() for decision of whether to defrag
  e4defrag: Allow user who has read+write permission to defrag
  e4defrag: Fix memory leak in file_defrag()
  e4defrag: Use blk64_t instead of ext4_fsblk_t
  e4defrag: Use EXT2_SUPER_MAGIC instead of EXT4_SUPER_MAGIC
  e4defrag: Fix error messages more clearly
  e4defrag: Remove unnecessary code

 lib/e2p/Makefile.in      |    6 
 lib/e2p/e2p.h            |    2 
 lib/e2p/fragment_score.c |  142 +++++++
 misc/Makefile.in         |    8 
 misc/e4defrag.8.in       |   30 -
 misc/e4defrag.c          |  889 +++++------------------------------------------
 misc/filefrag.c          |   28 +
 7 files changed, 288 insertions(+), 817 deletions(-)

Regards,
Kazuya Mio
