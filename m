Return-Path: <SRS0=2LTm=4Q=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0F3C3F2C6
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Feb 2020 01:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C80F42469D
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Feb 2020 01:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgB1BOR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 27 Feb 2020 20:14:17 -0500
Received: from mga07.intel.com ([134.134.136.100]:33279 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgB1BOR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Feb 2020 20:14:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 17:14:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="411241389"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2020 17:14:15 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j7UEI-0001HM-9n; Fri, 28 Feb 2020 09:14:14 +0800
Date:   Fri, 28 Feb 2020 03:18:48 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     kbuild-all@lists.01.org, jack@suse.cz, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCHv4 5/6] ext4: Move ext4_fiemap to use iomap framework.
Message-ID: <202002280303.ERVhiFtH%lkp@intel.com>
References: <2341a116e39ff0934b1f90aee8f4e10ac0371648.1582800839.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2341a116e39ff0934b1f90aee8f4e10ac0371648.1582800839.git.riteshh@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Ritesh,

I love your patch! Perhaps something to improve:

[auto build test WARNING on ext4/dev]
[also build test WARNING on linus/master v5.6-rc3 next-20200227]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Ritesh-Harjani/ext4-bmap-fiemap-conversion-to-use-iomap/20200227-204414
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-173-ge0787745-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> fs/ext4/extents.c:4918:24: sparse: sparse: symbol 'ext4_iomap_xattr_ops' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
