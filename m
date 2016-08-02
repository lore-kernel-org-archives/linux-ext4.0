From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 1038/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 20:10:47 +0800
Message-ID: <20160802121047.19315-1-baolex.ni@intel.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, mhalcrow@google.com,
	kirill.shutemov@linux.intel.com, oneukum@suse.com
To: tytso@mit.edu, adilger.kernel@dilger.ca, david.vrabel@citrix.com,
	tomi.valkeinen@ti.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13485 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965576AbcHBMwm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2016 08:52:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 fs/ext4/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 6a6c273..40877aa 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -42,10 +42,10 @@
 static unsigned int num_prealloc_crypto_pages = 32;
 static unsigned int num_prealloc_crypto_ctxs = 128;
 
-module_param(num_prealloc_crypto_pages, uint, 0444);
+module_param(num_prealloc_crypto_pages, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_prealloc_crypto_pages,
 		 "Number of crypto pages to preallocate");
-module_param(num_prealloc_crypto_ctxs, uint, 0444);
+module_param(num_prealloc_crypto_ctxs, uint, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(num_prealloc_crypto_ctxs,
 		 "Number of crypto contexts to preallocate");
 
-- 
2.9.2

