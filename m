From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:crypto 15/21] fs/ext4/crypto_fname.c:322:5: sparse: symbol
 'ext4_fname_decrypt' was not declared. Should it be static?
Date: Fri, 16 Jan 2015 10:27:32 +0800
Message-ID: <201501161021.CZOoWii2%fengguang.wu@intel.com>
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
head:   e32261a72a3c0c6c59d761820d8ca8b7c90008af
commit: 6b8813e5baf3aa99baec11610cc29bc4ed20e671 [15/21] ext4 crypto: filename encryption facilities
reproduce:
  # apt-get install sparse
  git checkout 6b8813e5baf3aa99baec11610cc29bc4ed20e671
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/crypto_fname.c:322:5: sparse: symbol 'ext4_fname_decrypt' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:380:5: sparse: symbol 'ext4_fname_encode_digest' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:479:6: sparse: symbol 'ext4_free_fname_crypto_ctx' was not declared. Should it be static?
>> fs/ext4/crypto_fname.c:532:30: sparse: symbol 'ext4_alloc_fname_crypto_ctx' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
