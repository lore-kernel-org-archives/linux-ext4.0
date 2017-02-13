From: kbuild test robot <fengguang.wu@intel.com>
Subject: [ext4:lazy_journal 31/36] fs/jbd2/jmap.c:19:2-20: WARNING: NULL
 check before freeing functions like kfree, debugfs_remove,
 debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
 reorganizing relevant code to avoid passing NULL values.
Date: Mon, 13 Feb 2017 15:31:19 +0800
Message-ID: <201702131515.Cca34rb0%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-ext4@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
To: Abutalib Aghayev <agayev@cs.cmu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32560 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdBMHb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 13 Feb 2017 02:31:56 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git lazy_journal
head:   c3a5aefebea108e050865d5bdf9fd11b9c7f6c5e
commit: 8ee808a5a2c58937a6b80022e2a1bc18894009d6 [31/36] Add support for tracking metadata blocks in the log.


coccinelle warnings: (new ones prefixed by >>)

>> fs/jbd2/jmap.c:19:2-20: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
