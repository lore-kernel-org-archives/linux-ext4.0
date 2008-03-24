From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Mon, 24 Mar 2008 21:34:51 +0900
Message-ID: <200803241234.AA00346@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	a-fujita@rs.jp.nec.com
To: aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36551 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbYCXMhZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 08:37:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,
> On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
>>>   
>> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
>> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
>> in ext4 online defrag when kernel supports it.
>
> Can you also look at the sparse warnings with the patches ?
>
I have already released the fixed patch before, but it is not in the ext4 patch queue yet.
Mingming, could you replace new ext4-online-defrag-free-space-fragmentation.patch
with old one in the ext4 patch queue? 

Regards, Akira

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 defrag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff -Nurp linux-2.6.25-rc6-full/fs/ext4/defrag.c linux-2.6.25-rc6-fix/fs/ext4/defrag.c
--- linux-2.6.25-rc6-full/fs/ext4/defrag.c    2008-03-24 20:37:10.000000000 +0900
+++ linux-2.6.25-rc6-fix/fs/ext4/defrag.c    2008-03-24 20:40:22.000000000 +0900
@@ -454,7 +454,7 @@ static int ext4_defrag_move_victim(struc
             ext_info->ext[i].len, goal, DEFRAG_FORCE_VICTIM, &ext);
         if (ret < 0) {
             printk(KERN_ERR "ext4 defrag: "
-                "Moving victim file failed. ino [%lu]\n",
+                "Moving victim file failed. ino [%llu]\n",
                 ext_info->ino);
             goto err;
         }
