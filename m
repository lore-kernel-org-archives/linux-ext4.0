From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:dev 37/63] fs/ext4/inline.c:268:19: error:
 'empty_zero_page' undeclared
Date: Tue, 11 Dec 2012 06:02:40 +0800
Message-ID: <50c65c00.3GZ66LxGua+Gl+1Q%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <boyu.mt@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab2LJWD3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 17:03:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   9a4c8019471386c6fb039ae9e30f5216b6b55a9e
commit: 67cf5b09a46f72e048501b84996f2f77bc42e947 [37/63] ext4: add the basic function for inline data support
config: make ARCH=sparc allyesconfig

All error/warnings:

fs/ext4/inline.c: In function 'ext4_create_inline_data':
fs/ext4/inline.c:268:19: error: 'empty_zero_page' undeclared (first use in this function)
fs/ext4/inline.c:268:19: note: each undeclared identifier is reported only once for each function it appears in
fs/ext4/inline.c: At top level:
fs/ext4/inline.c:164:12: warning: 'ext4_read_inline_data' defined but not used [-Wunused-function]

vim +268 +/empty_zero_page fs/ext4/inline.c

67cf5b09 Tao Ma 2012-12-10  262  
67cf5b09 Tao Ma 2012-12-10  263  	error = ext4_journal_get_write_access(handle, is.iloc.bh);
67cf5b09 Tao Ma 2012-12-10  264  	if (error)
67cf5b09 Tao Ma 2012-12-10  265  		goto out;
67cf5b09 Tao Ma 2012-12-10  266  
67cf5b09 Tao Ma 2012-12-10  267  	if (len > EXT4_MIN_INLINE_DATA_SIZE) {
67cf5b09 Tao Ma 2012-12-10 @268  		value = (void *)empty_zero_page;
67cf5b09 Tao Ma 2012-12-10  269  		len -= EXT4_MIN_INLINE_DATA_SIZE;
67cf5b09 Tao Ma 2012-12-10  270  	} else {
67cf5b09 Tao Ma 2012-12-10  271  		value = "";

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
