From: Marcus Huewe <suse-tux@gmx.de>
Subject: [PATCH 0/2] mke2fs -E offset=N filessystem size calculation
Date: Thu, 12 May 2016 18:21:55 +0200
Message-ID: <20160512162155.GA4618@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52395 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbcELQWB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 May 2016 12:22:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

it seems that commit 87d9b2fb broke the filesystem size calculation, if
mke2fs is called with the offset option ("-E offset=N") and an explicitly
specified filesystem size.
This series fixes it and documents the expected behavior (see adjusted
testcase).


Marcus

Marcus Huewe (2):
  tests: test "mke2fs -E offset=N" filesystem size calculation
  mke2fs: fix filesystem size calculation, if an offset is specified

 misc/mke2fs.c                |  3 ++-
 tests/t_mke2fs_offset/script | 28 +++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.6.3

