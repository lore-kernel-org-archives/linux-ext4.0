From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [RFC] ext4_bmap() may return blocks outside filesystem
Date: Thu, 05 Feb 2009 13:03:23 +0100
Message-ID: <498AD58B.5000805@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000700080307090007020903"
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:46306 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZBEMDc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 07:03:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000700080307090007020903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

during testing of ext4 with intentionally corrupted filesystem images I 
noticed that sometimes ext4_bmap() returns physical block numbers which 
lie outside of the filesystem.  In most cases, the error is caught by 
the block layer (?) leading to error messages of the kind:

attempt to access beyond end of device
loop0: rw=0, want=xxx, limit=xxx

But there also are cases which are not handled gracefully by bmap() callers.

I've attached a conceptual patch against 2.6.29-rc2 which fixes one case 
in which invalid block numbers are returned (there might be more) by 
adding sanity checks to ext4_ext_find_extent(), but before I start 
looking for further occurences, I'd like to ask whether you think my 
approach is reasonable.

Kind regards,

Thiemo Nagel

--------------000700080307090007020903
Content-Type: text/x-patch;
 name="concept.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="concept.patch"

--- ../download/linux-2.6.29-rc2-vanilla/fs/ext4/extents.c	2009-02-05 12:31:19.000000000 +0100
+++ fs/ext4/extents.c	2009-02-05 12:42:49.000000000 +0100
@@ -595,8 +595,15 @@
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
 	/* if not an empty leaf */
-	if (path[ppos].p_ext)
+	if (path[ppos].p_ext) {
 		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
+               if (path[ppos].p_block < EXT4_SB(inode->i_sb)->s_es->s_first_data_block
+                   || path[ppos].p_block + path[ppos].p_ext->ee_len
+                      >= ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es)) {
+                       printk("ext4_ext_find_extent: extent out of range\n");
+                       goto err;
+               }
+       }
 
 	ext4_ext_show_path(inode, path);
 

--------------000700080307090007020903--
