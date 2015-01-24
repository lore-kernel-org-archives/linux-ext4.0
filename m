From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:crypto 17/19] fs/ext4/namei.c:2056:5: sparse: symbol
 'ext4_find_dest_de_crypt' was not declared. Should it be static?
Date: Sat, 24 Jan 2015 08:33:40 +0800
Message-ID: <201501240824.lsZlTlwQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git crypto
head:   dfc8aa97bd527d156f6e7ee3f0286af2229be45d
commit: 2842df91db1447a594331116ee48fbf4647b3dd0 [17/19] ext4 crypto: filename encryption modifications
reproduce:
  # apt-get install sparse
  git checkout 2842df91db1447a594331116ee48fbf4647b3dd0
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/namei.c:2056:5: sparse: symbol 'ext4_find_dest_de_crypt' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
