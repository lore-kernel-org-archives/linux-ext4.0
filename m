From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] ext4: check block references only when read from disk
Date: Thu, 12 Mar 2009 18:20:00 +0100
Message-ID: <49B94440.4010602@ph.tum.de>
References: <49B94396.2020800@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020607050801030309060300"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:45651 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbZCLRUD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 13:20:03 -0400
In-Reply-To: <49B94396.2020800@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020607050801030309060300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

And this one should limit the checks to freshly-read block only.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>



--------------020607050801030309060300
Content-Type: text/x-patch;
 name="check-blockrefs-only-when-read-from-disk_vs_2.6.29-rc7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="check-blockrefs-only-when-read-from-disk_vs_2.6.29-rc7.patch"

--- download/linux-2.6.29-rc7-vanilla-extcheck/fs/ext4/inode.c	2009-03-12 16:44:19.000000000 +0100
+++ linux-2.6.29-rc7/fs/ext4/inode.c	2009-03-12 16:40:28.000000000 +0100
@@ -443,12 +443,20 @@
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_bread(sb, le32_to_cpu(p->key));
-		if (!bh)
-			goto failure;
-		if (ext4_check_indirect_blockref(inode, bh))
+		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		if (unlikely(!bh))
 			goto failure;
                   
+		if (!bh_uptodate_or_lock(bh)) {
+			if (bh_submit_read(bh) < 0) {
+				put_bh(bh);
+				goto failure;
+			}
+			/* validate the extent entries */
+			if (ext4_check_indirect_blockref(inode, bh))
+				goto failure;
+		}
+		
 		add_chain(++p, bh, (__le32 *)bh->b_data + *++offsets);
 		/* Reader: end */
 		if (!p->key)

--------------020607050801030309060300--
