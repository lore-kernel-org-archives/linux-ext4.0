From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] off-by-one in "Add checks to validate extent entries."
Date: Thu, 02 Apr 2009 19:12:55 +0200
Message-ID: <49D4F217.7050105@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:41243 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbZDBRM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Apr 2009 13:12:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
 > I haven't had time yet to check your other patches; could you also
 > take a quick scan to make sure we have all of the byte-swapping calls
 > needed for proper big-endian checking, that we're using the correct
 > __le32 types and not doing any casts?

I had a look at all patches I have sent, but I didn't notice anything 
suspicious.  While doing that, however I think I found an off-by-one in
56b19868aca856a7d7bf20c3a7a1030e4fd75b2b

Kind regards,

Thiemo

---
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ac77d8b..6132353 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -342,7 +342,7 @@ static int ext4_valid_extent_idx(struct inode *inode,
         ext4_fsblk_t block = idx_pblock(ext_idx);
         struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
         if (unlikely(block < le32_to_cpu(es->s_first_data_block) ||
-                       (block > ext4_blocks_count(es))))
+                       (block >= ext4_blocks_count(es))))
                 return 0;
         else
                 return 1;
