From: Dai Xiang <xiangx.dai@intel.com>
Subject: How to enable CONFIG_EXT4_ENCRYPTION
Date: Mon, 7 Aug 2017 11:25:02 +0800
Message-ID: <20170807032502.2tiyjybtqrn6odab@linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Dai <xiangx.dai@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:57028 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbdHGDZE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 23:25:04 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

I use xfstests with ext4 fs to test, and i found a skip:

ext4/024         [not run] kernel does not support ext4 encryption

I have rebuild config with CONFIG_FS_ENCRYPTION and CONFIG_EXT4_ENCRYPTION.
I try to set them both y and both m, but two ways both do not set and do not find related failure log.
I use v4.13-rc3 kernel to build.

Do i miss some dependence kconfig?

Thanks
Xiang
