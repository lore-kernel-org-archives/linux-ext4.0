From: "George Spelvin" <linux@horizon.com>
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Date: 10 Dec 2013 19:57:51 -0500
Message-ID: <20131211005751.9957.qmail@science.horizon.com>
References: <20131210152701.GE1543@quack.suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu,
	viro@ZenIV.linux.org.uk
To: jack@suse.cz, linux@horizon.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131210152701.GE1543@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  Hum, can you try disabling the HW support of CRC32C implementation
> (CRYPTO_CRC32C_INTEL)? If the problem disappears, we know there's some
> problem in the HW support code...

To isolate it even better, I left in the hardware support, but commented
out the CLMUL code.  I could have just upped the threshold, but opted
for commenting it out completely.

commit 8ebf85f2c151e4568d948bda29f39396ccc11096
Author: George Spelvin <linux@horizon.com>
Date:   Tue Dec 10 21:06:40 2013 +0000

    Disable Intel crc32c PCLMULQ usage
    
    It's a great hack, but uses the FPU, and that appears to cause problems.

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index 0c8b502..e7b44fd 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -183,11 +183,11 @@ static int crc32c_pcl_intel_update(struct shash_desc *desc, const u8 *data,
 	 * use faster PCL version if datasize is large enough to
 	 * overcome kernel fpu state save/restore overhead
 	 */
-	if (len >= crc32c_pcl_breakeven && irq_fpu_usable()) {
-		kernel_fpu_begin();
-		*crcp = crc_pcl(data, len, *crcp);
-		kernel_fpu_end();
-	} else
+//	if (len >= crc32c_pcl_breakeven && irq_fpu_usable()) {
+//		kernel_fpu_begin();
+//		*crcp = crc_pcl(data, len, *crcp);
+//		kernel_fpu_end();
+//	} else
 		*crcp = crc32c_intel_le_hw(*crcp, data, len);
 	return 0;
 }
@@ -195,11 +195,11 @@ static int crc32c_pcl_intel_update(struct shash_desc *desc, const u8 *data,
 static int __crc32c_pcl_intel_finup(u32 *crcp, const u8 *data, unsigned int len,
 				u8 *out)
 {
-	if (len >= crc32c_pcl_breakeven && irq_fpu_usable()) {
-		kernel_fpu_begin();
-		*(__le32 *)out = ~cpu_to_le32(crc_pcl(data, len, *crcp));
-		kernel_fpu_end();
-	} else
+//	if (len >= crc32c_pcl_breakeven && irq_fpu_usable()) {
+//		kernel_fpu_begin();
+//		*(__le32 *)out = ~cpu_to_le32(crc_pcl(data, len, *crcp));
+//		kernel_fpu_end();
+//	} else
 		*(__le32 *)out =
 			~cpu_to_le32(crc32c_intel_le_hw(*crcp, data, len));
 	return 0;
