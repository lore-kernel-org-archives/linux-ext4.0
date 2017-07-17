From: "Liu, Emoly" <emoly.liu@intel.com>
Subject: RE: [PATCH] ext4: error should be cleared if ea_inode isn't added
 to the cache
Date: Mon, 17 Jul 2017 02:12:34 +0000
Message-ID: <07A0E441A926DB4D91D25518F435CC777C9D62FD@SHSMSX104.ccr.corp.intel.com>
References: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58255 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbdGQCMi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 16 Jul 2017 22:12:38 -0400
In-Reply-To: <1499831813-13218-1-git-send-email-emoly.liu@intel.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This patch needs to be included into the release along with the ea_inode feature to maintain proper feature compatibility with Lustre.
Could it be landed as soon as possible?

Thanks,
Emoly

-----Original Message-----
From: Emoly Liu [mailto:emoly.liu@intel.com] 
Sent: Wednesday, July 12, 2017 11:57 AM
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org; Liu, Emoly <emoly.liu@intel.com>
Subject: [PATCH] ext4: error should be cleared if ea_inode isn't added to the cache

For Lustre, if ea_inode fails in hash validation but passes parent inode and generation checks, it won't be added to the cache as well as the error "-EFSCORRUPTED" should be cleared, otherwise it will cause "Structure needs cleaning" when running getfattr command.

Signed-off-by: Emoly Liu <emoly.liu@intel.com>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9723
---
 fs/ext4/xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c index cff4f41..de217a0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -451,6 +451,7 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 		}
 		/* Do not add ea_inode to the cache. */
 		ea_inode_cache = NULL;
+		err = 0;
 	} else if (err)
 		goto out;
 
--
1.8.3.1
