From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:crypto 8/21] fs/ext4/xattr_encryption.c:80:5: sparse: symbol
 'ext4_xattr_encryption_context_set' was not declared. Should it be static?
Date: Fri, 16 Jan 2015 10:07:13 +0800
Message-ID: <201501161001.0s7ByimN%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git crypto
head:   e32261a72a3c0c6c59d761820d8ca8b7c90008af
commit: db813a4cea85922497d58e94304d75517576af03 [8/21] ext4 crypto: add encryption xattr support
reproduce:
  # apt-get install sparse
  git checkout db813a4cea85922497d58e94304d75517576af03
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/xattr_encryption.c:80:5: sparse: symbol 'ext4_xattr_encryption_context_set' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
