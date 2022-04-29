Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79298C433EF
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Apr 2022 05:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351285AbiD2FnR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Apr 2022 01:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbiD2FnQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Apr 2022 01:43:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E704D9DA
        for <linux-ext4@vger.kernel.org>; Thu, 28 Apr 2022 22:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651210799; x=1682746799;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Op5OsO4DO/H0TOFJ8Y7/W+N96i75JcfxWveF6JmHGNE=;
  b=XgiGlEV97r7GdFJLvzvW1F4od6kv5n2cCkeoY0LtNgdGoODo1ABEGjPF
   OWy8i+1HH+9U+E7WtpXtHERrb7zimu1APtRUSZKk34DgwoBmwiOMNRjDo
   I/GVUnR9ZyhjAO+55J/oblcVMUen8/WLu+2K6GgJ8jqlwFPOJG35lDxwZ
   KmBj+uX8wSo/+lQsYWzOmPanCU4OPLluSWk9Dvt2sqXF8VftjDkGml3Lg
   ZgQTlJt3QUKcIXJfaSeD3hn9Y379LXJdBYlvWIyFxakdwiEby0Nr6+ISh
   JpW/yQjHLwLk68Q+7QaJaGWHDHibHfFpI3Kj2SaJXfWxrI62w3CLVdhpV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="253923742"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="253923742"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 22:39:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="597172094"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Apr 2022 22:39:57 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nkJMC-00062B-Dj;
        Fri, 29 Apr 2022 05:39:56 +0000
Date:   Fri, 29 Apr 2022 13:39:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org
Cc:     kbuild-all@lists.01.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, ebiggers@kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: Re: [PATCH v2 6/7] ext4: Move ext4_match_ci into libfs
Message-ID: <202204291327.Jwfp0oHk-lkp@intel.com>
References: <20220428221027.269084-7-krisman@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428221027.269084-7-krisman@collabora.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Gabriel,

I love your patch! Yet something to improve:

[auto build test ERROR on tytso-ext4/dev]
[also build test ERROR on jaegeuk-f2fs/dev-test linus/master v5.18-rc4 next-20220428]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Gabriel-Krisman-Bertazi/Clean-up-the-case-insenstive-lookup-path/20220429-061233
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
config: microblaze-buildonly-randconfig-r004-20220428 (https://download.01.org/0day-ci/archive/20220429/202204291327.Jwfp0oHk-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/51d480019fcf38c09d664fc2d459907908b62615
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Gabriel-Krisman-Bertazi/Clean-up-the-case-insenstive-lookup-path/20220429-061233
        git checkout 51d480019fcf38c09d664fc2d459907908b62615
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=microblaze SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "generic_ci_match" [fs/ext4/ext4.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
