Return-Path: <SRS0=afbN=SJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE15C282DA
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 01:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66376213A2
	for <linux-ext4@archiver.kernel.org>; Sun,  7 Apr 2019 01:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfDGBeH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 6 Apr 2019 21:34:07 -0400
Received: from mga06.intel.com ([134.134.136.31]:56835 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfDGBeH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 6 Apr 2019 21:34:07 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Apr 2019 18:34:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,319,1549958400"; 
   d="scan'208";a="140585407"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 06 Apr 2019 18:34:06 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hCwhB-000DRv-Nq; Sun, 07 Apr 2019 09:34:05 +0800
Date:   Sun, 7 Apr 2019 09:33:44 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Cc:     kbuild-all@01.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: [ext4:unicode 4/10] fs/unicode/utf8-norm.c:41:24: sparse: non-ANSI
 function declaration of function 'utf8version_latest'
Message-ID: <201904070943.WPSdOu81%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git unicode
head:   c0ae3a05c89c497446d6e208b68623993b5afc3c
commit: 45568caefa60a247ce9ecee3f4a57d1f81f5dd0e [4/10] unicode: implement higher level API for string handling
reproduce:
        # apt-get install sparse
        git checkout 45568caefa60a247ce9ecee3f4a57d1f81f5dd0e
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

>> fs/unicode/utf8-norm.c:41:24: sparse: non-ANSI function declaration of function 'utf8version_latest'

vim +/utf8version_latest +41 fs/unicode/utf8-norm.c

    40	
  > 41	int utf8version_latest()
    42	{
    43		return utf8vers;
    44	}
    45	EXPORT_SYMBOL(utf8version_latest);
    46	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
