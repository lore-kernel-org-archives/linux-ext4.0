From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 39/57] (.text+0x10b24): multiple definition of
 `walk_page_buffers'
Date: Mon, 03 Dec 2012 12:31:13 +0800
Message-ID: <50bc2b11.LsekEeO+H00dsdNO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab2LCEch (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Dec 2012 23:32:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   b0c30cdb0d3fcf5a04de4a46fceba767cf8be022
commit: c99dcc3889f574139c8c8a2699664dc31bccd415 [39/57] ext4: add normal write support for inline data
config: make ARCH=i386 allyesconfig

All error/warnings:

fs/ocfs2/built-in.o: In function `walk_page_buffers':
(.text+0x10b24): multiple definition of `walk_page_buffers'
fs/ext4/built-in.o:(.text+0x72b3): first defined here

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
