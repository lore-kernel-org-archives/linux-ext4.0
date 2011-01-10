From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: don't pass entire map to check_eofblocks_fl
Date: Mon, 10 Jan 2011 11:55:07 -0600
Message-ID: <4D2B47FB.1040909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1AJRzI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 12:55:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0AHt8Lk027037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 12:55:08 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p0AHt7E8018028
	for <linux-ext4@vger.kernel.org>; Mon, 10 Jan 2011 12:55:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Since check_eofblocks_fl() only uses the m_lblk portion of
the map structure, we may as well pass that directly, rather
than passing the entire map, which IMHO obfuscates what
parameters check_eofblocks_fl() cares about.  Not a big
deal, but seems tidier and less confusing, to me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..b5bbb9f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3082,7 +3082,7 @@ static void unmap_underlying_metadata_blocks(struct block_device *bdev,
  * Handle EOFBLOCKS_FL flag, clearing it if necessary
  */
 static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
-			      struct ext4_map_blocks *map,
+			      ext4_lblk_t lblk,
 			      struct ext4_ext_path *path,
 			      unsigned int len)
 {
@@ -3112,7 +3112,7 @@ static int check_eofblocks_fl(handle_t *handle, struct inode *inode,
 	 * this turns out to be false, we can bail out from this
 	 * function immediately.
 	 */
-	if (map->m_lblk + len < le32_to_cpu(last_ex->ee_block) +
+	if (lblk + len < le32_to_cpu(last_ex->ee_block) +
 	    ext4_ext_get_actual_len(last_ex))
 		return 0;
 	/*
@@ -3168,8 +3168,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 							path);
 		if (ret >= 0) {
 			ext4_update_inode_fsync_trans(handle, inode, 1);
-			err = check_eofblocks_fl(handle, inode, map, path,
-						 map->m_len);
+			err = check_eofblocks_fl(handle, inode, map->m_lblk,
+						 path, map->m_len);
 		} else
 			err = ret;
 		goto out2;
@@ -3199,7 +3199,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 	ret = ext4_ext_convert_to_initialized(handle, inode, map, path);
 	if (ret >= 0) {
 		ext4_update_inode_fsync_trans(handle, inode, 1);
-		err = check_eofblocks_fl(handle, inode, map, path, map->m_len);
+		err = check_eofblocks_fl(handle, inode, map->m_lblk, path,
+					 map->m_len);
 		if (err < 0)
 			goto out2;
 	}
@@ -3456,7 +3457,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			map->m_flags |= EXT4_MAP_UNINIT;
 	}
 
-	err = check_eofblocks_fl(handle, inode, map, path, ar.len);
+	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
 	if (err)
 		goto out2;
 

