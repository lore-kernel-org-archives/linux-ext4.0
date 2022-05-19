Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5621DC433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 19 May 2022 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbiESUMj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 19 May 2022 16:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiESUMi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2022 16:12:38 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D73C3D12
        for <linux-ext4@vger.kernel.org>; Thu, 19 May 2022 13:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652991157; x=1684527157;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=QennQp5LPM9aFmphQ4Wal8H49G93bJYru095k5uVdpQ=;
  b=kyE4Eu/fUyh7uO07w4mJ5sPgl4vX3oq6svVSZKY2HHJLnaZ7R1a/rjQp
   +m4w5KlKLnaLLGPb4EfIT9ZE+MXteMc3ELx+QvHjOACo8rZJQmzBIaNAT
   j1kJQ4goxhZAdzI9V8RRsmv7ToB36Hdj3LrnD8QTr4qpybrWe31UV5vSk
   KG3cpzjba767a0sfmsXfAkWOvFqAERlHto0HcxIhHs8UqM9pooA4gIAIJ
   rsfPjIPGUiLDfQNDsM+CLQZDG8l/YVvOEAQOpRx48EBvcy7I7mLrIp86F
   dZFwuJCYdSPO3B8c6pw9wfjXl1//Ie5k4BQjznv1nGxoSQVE2ioLywBz3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271184457"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271184457"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 13:12:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="546293174"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 19 May 2022 13:12:35 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrmVd-0003ur-Bz;
        Thu, 19 May 2022 20:12:33 +0000
Date:   Fri, 20 May 2022 04:12:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Biggers <ebiggers@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: [tytso-ext4:dev 17/25] fs/ext4/super.c:2799:29: warning: unused
 variable 'sbi'
Message-ID: <202205200431.kzojEoNc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
head:   b76a7dd9a7437e8c21253ce3a7574bebde3827f9
commit: 0df27ddf69f38e5ab1e1c73e46c35eecc6ca1609 [17/25] ext4: only allow test_dummy_encryption when supported
config: i386-randconfig-a004 (https://download.01.org/0day-ci/archive/20220520/202205200431.kzojEoNc-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project e00cbbec06c08dc616a0d52a20f678b8fbd4e304)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?id=0df27ddf69f38e5ab1e1c73e46c35eecc6ca1609
        git remote add tytso-ext4 https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
        git fetch --no-tags tytso-ext4 dev
        git checkout 0df27ddf69f38e5ab1e1c73e46c35eecc6ca1609
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/ext4/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/ext4/super.c:2799:29: warning: unused variable 'sbi' [-Wunused-variable]
           const struct ext4_sb_info *sbi = EXT4_SB(sb);
                                      ^
   1 warning generated.


vim +/sbi +2799 fs/ext4/super.c

  2794	
  2795	static int ext4_check_test_dummy_encryption(const struct fs_context *fc,
  2796						    struct super_block *sb)
  2797	{
  2798		const struct ext4_fs_context *ctx = fc->fs_private;
> 2799		const struct ext4_sb_info *sbi = EXT4_SB(sb);
  2800	
  2801		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION) ||
  2802		    !(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION))
  2803			return 0;
  2804	
  2805		if (!ext4_has_feature_encrypt(sb)) {
  2806			ext4_msg(NULL, KERN_WARNING,
  2807				 "test_dummy_encryption requires encrypt feature");
  2808			return -EINVAL;
  2809		}
  2810		/*
  2811		 * This mount option is just for testing, and it's not worthwhile to
  2812		 * implement the extra complexity (e.g. RCU protection) that would be
  2813		 * needed to allow it to be set or changed during remount.  We do allow
  2814		 * it to be specified during remount, but only if there is no change.
  2815		 */
  2816		if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE &&
  2817		    !DUMMY_ENCRYPTION_ENABLED(sbi)) {
  2818			ext4_msg(NULL, KERN_WARNING,
  2819				 "Can't set test_dummy_encryption on remount");
  2820			return -EINVAL;
  2821		}
  2822		return 0;
  2823	}
  2824	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
