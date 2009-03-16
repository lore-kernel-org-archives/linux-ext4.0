From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: do less extent validations
Date: Mon, 16 Mar 2009 20:05:30 +0100
Message-ID: <49BEA2FA.5070703@ph.tum.de>
References: <49B92B26.70402@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090908020106060405090107"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:57011 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbZCPTGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 15:06:20 -0400
In-Reply-To: <49B92B26.70402@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090908020106060405090107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thiemo Nagel wrote:
> 
> Based on 2.6.29-rc7 with Aneesh Kumar's patches:
> ext4: Validate extent details only when read from the disk
> ext4: Add checks to validate extent entries
> 
> Sets need_to_validate=0 inside instead of outside the loop.

OTOH, why not remove the variable altogether?  (cf. attached patch)

Kind regards,

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

-- 
+-----------------------------------+--------------------------+
| Dipl.-Phys. Thiemo Nagel          |                          |
| Technische Universitaet Muenchen  | Room    PH1 3276         |
| Physik-Department E18             |                          |
| James-Franck-Strasse              | Phone  +49 89 289-12379  |
| D-85747 Garching                  | Fax    +49 89 289-12570  |
+-----------------------------------+--------------------------+


--------------090908020106060405090107
Content-Type: text/plain;
 name="less-extent-validations.patch2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="less-extent-validations.patch2"

--- linux-2.6.29-rc8/fs/ext4/extents.c~	2009-03-16 19:37:22.000000000 +0100
+++ linux-2.6.29-rc8/fs/ext4/extents.c	2009-03-16 19:50:33.000000000 +0100
@@ -607,7 +607,6 @@
 ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 					struct ext4_ext_path *path)
 {
-	int need_to_validate = 0;
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
@@ -646,17 +645,16 @@
 				goto err;
 			}
 			/* validate the extent entries */
-			need_to_validate = 1;
+			if (ext4_ext_check(inode, eh, i))
+				goto err;
 		}
+
 		eh = ext_block_hdr(bh);
 		ppos++;
 		BUG_ON(ppos > depth);
 		path[ppos].p_bh = bh;
 		path[ppos].p_hdr = eh;
 		i--;
--------------090908020106060405090107--
