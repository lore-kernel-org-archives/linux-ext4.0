From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] off-by-one in "Add checks to validate extent entries."
Date: Sun, 05 Apr 2009 12:21:03 +0200
Message-ID: <49D8860F.6070002@ph.tum.de>
References: <49D4F217.7050105@ph.tum.de> <20090405032438.GI7553@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:54679 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758474AbZDEKVJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Apr 2009 06:21:09 -0400
In-Reply-To: <20090405032438.GI7553@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Apr 02, 2009 at 07:12:55PM +0200, Thiemo Nagel wrote:
>> Theodore Tso wrote:
>>> I haven't had time yet to check your other patches; could you also
>>> take a quick scan to make sure we have all of the byte-swapping calls
>>> needed for proper big-endian checking, that we're using the correct
>>> __le32 types and not doing any casts?
>> I had a look at all patches I have sent, but I didn't notice anything  
>> suspicious.  While doing that, however I think I found an off-by-one in
>> 56b19868aca856a7d7bf20c3a7a1030e4fd75b2b
> 
> In the future, could you please remember to include a Signed-off-by:
> for your patches?
> 
> Thanks!!
> 
> This one is simple enough that I'll just include it, but I'd really
> prefer to get explicit signed-off patches.

Ok.  So just for the record:

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

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


-- 
+-----------------------------------+--------------------------+
| Dipl.-Phys. Thiemo Nagel          |                          |
| Technische Universitaet Muenchen  | Room    PH1 3276         |
| Physik-Department E18             |                          |
| James-Franck-Strasse              | Phone  +49 89 289-12379  |
| D-85747 Garching                  | Fax    +49 89 289-12570  |
+-----------------------------------+--------------------------+
