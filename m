From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 00/11] e4defrag: fragmentation score rework and cleanups
Date: Mon, 14 Nov 2011 15:23:44 +0900
Message-ID: <4EC0B3F0.4060501@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:51584 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1KNGhk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:37:40 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id pAE6bcnF024368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Nov 2011 15:37:38 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch set adds the new function e2p_get_fragscore() to libe2p, that
calculates the fragmentation score. Fragmentation score shows how badly
fragmented the file might be. e4defrag uses it to determine smarter whether to
call EXT4_IOC_MOVE_EXT ioctl.

In addition, the 6th to the last is bugfix or cleanup patch.

v2 -> v3

- Don't treat integer variables as boolean in some conditions for good
  readability
- Output the progress of the defrag like mke2fs to reduce log file size
- Revert to checking st_blocks to skip defrag safety if file has no blocks

Thanks for the above helpful comments, Dilger.

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

This patch set is for e2fsprogs git tree. (commit:6b967cd6f1)

Kazuya Mio (11):
  libe2p: Add new function e2p_get_fragscore()
  e4defrag: Remove -c option which checks the file fragmentation
  e4defrag: Remove old fragmentation score calculation code
  e4defrag: Use e2p_get_fragscore() for decision of whether to defrag
  e4defrag: Add -F option for force defrag
  e4defrag: Allow user who has read+write permission to defrag
  e4defrag: Allow user who can use reserved blocks to defrag
  e4defrag: Use libext2fs definitions
  e4defrag: Fix error messages more clearly
  e4defrag: Fix the method of progress output
  e4defrag: Remove unnecessary code

 lib/e2p/Makefile.in      |    6 
 lib/e2p/e2p.h            |    3 
 lib/e2p/fragment_score.c |  133 ++++++
 misc/Makefile.in         |    4 
 misc/e4defrag.8.in       |   33 -
 misc/e4defrag.c          |  950 +++++++----------------------------------------
 6 files changed, 290 insertions(+), 839 deletions(-)

Regards,
Kazuya Mio
