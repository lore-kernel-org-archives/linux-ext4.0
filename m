Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:45833 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbeKUAGY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 20 Nov 2018 19:06:24 -0500
Date: Tue, 20 Nov 2018 21:36:39 +0800
From: kbuild test robot <lkp@intel.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: kbuild-all@01.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
Subject: Re: [PATCH] ext4: add ext4_sb_bread() to disambiguate ENOMEM cases
Message-ID: <201811202145.0H2GYODQ%fengguang.wu@intel.com>
References: <20181117233523.8832-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181117233523.8832-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Theodore,

I love your patch! Perhaps something to improve:

[auto build test WARNING on ext4/dev]
[also build test WARNING on v4.20-rc3 next-20181120]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Theodore-Ts-o/ext4-add-ext4_sb_bread-to-disambiguate-ENOMEM-cases/20181120-070629
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev


coccinelle warnings: (new ones prefixed by >>)

>> fs/ext4/resize.c:1000:9-16: ERROR: PTR_ERR applied after initialization to constant on line 989
--
>> fs/ext4/resize.c:999:6-12: inconsistent IS_ERR and PTR_ERR on line 1000.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
