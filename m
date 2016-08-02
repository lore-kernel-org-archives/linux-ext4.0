From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 1039/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 20:10:52 +0800
Message-ID: <20160802121052.19381-1-baolex.ni@intel.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com, mhalcrow@google.com,
	kirill.shutemov@linux.intel.com, oneukum@suse.com
To: tytso@mit.edu, adilger.kernel@dilger.ca, david.vrabel@citrix.com,
	tomi.valkeinen@ti.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec..12e4da5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -32,7 +32,7 @@
 #ifdef CONFIG_EXT4_DEBUG
 ushort ext4_mballoc_debug __read_mostly;
 
-module_param_named(mballoc_debug, ext4_mballoc_debug, ushort, 0644);
+module_param_named(mballoc_debug, ext4_mballoc_debug, ushort, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(mballoc_debug, "Debugging level for ext4's mballoc");
 #endif
 
-- 
2.9.2
