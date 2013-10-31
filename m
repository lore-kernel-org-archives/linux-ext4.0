From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove unreachable code after ext4_can_extents_be_merged()
Date: Thu, 31 Oct 2013 16:18:33 -0500
Message-ID: <5272C929.80303@redhat.com>
References: <5272C4E3.5040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab3JaVSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Oct 2013 17:18:34 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9VLIY5I028469
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 17:18:34 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r9VLIXct024194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 17:18:34 -0400
In-Reply-To: <5272C4E3.5040206@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit
ec22ba8e ext4: disable merging of uninitialized extents
 
ensured that if either extent under consideration is uninit,
we decline to merge, and ext4_can_extents_be_merged() returns false.

So there is no need for the caller to then test whether the
extent under consideration is unitialized; if it were, we
wouldn't have gotten that far.

The comments were also inaccurate; ext4_can_extents_be_merged()
no longer XORs the states, it fails if *either* is uninit.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Disclaimer: compile-tested only.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index de6d467..35f65cf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1715,7 +1715,6 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 	struct ext4_extent_header *eh;
 	unsigned int depth, len;
 	int merge_done = 0;
-	int uninitialized = 0;
 
 	depth = ext_depth(inode);
 	BUG_ON(path[depth].p_hdr == NULL);
@@ -1725,12 +1724,8 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
 			break;
 		/* merge with next extent! */
-		if (ext4_ext_is_uninitialized(ex))
-			uninitialized = 1;
 		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 				+ ext4_ext_get_actual_len(ex + 1));
-		if (uninitialized)
-			ext4_ext_mark_uninitialized(ex);
 
 		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
 			len = (EXT_LAST_EXTENT(eh) - ex - 1)
@@ -1885,7 +1880,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err;
 	ext4_lblk_t next;
-	unsigned uninitialized = 0;
 	int mb_flags = 0;
 
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
@@ -1937,18 +1931,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 			if (err)
 				return err;
 
-			/*
-			 * ext4_can_extents_be_merged should have checked
-			 * that either both extents are uninitialized, or
-			 * both aren't. Thus we need to check only one of
-			 * them here.
-			 */
-			if (ext4_ext_is_uninitialized(ex))
-				uninitialized = 1;
 			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 					+ ext4_ext_get_actual_len(newext));
-			if (uninitialized)
-				ext4_ext_mark_uninitialized(ex);
 			eh = path[depth].p_hdr;
 			nearex = ex;
 			goto merge;
@@ -1971,20 +1955,10 @@ prepend:
 			if (err)
 				return err;
 
-			/*
-			 * ext4_can_extents_be_merged should have checked
-			 * that either both extents are uninitialized, or
-			 * both aren't. Thus we need to check only one of
-			 * them here.
-			 */
-			if (ext4_ext_is_uninitialized(ex))
-				uninitialized = 1;
 			ex->ee_block = newext->ee_block;
 			ext4_ext_store_pblock(ex, ext4_ext_pblock(newext));
 			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 					+ ext4_ext_get_actual_len(newext));
-			if (uninitialized)
-				ext4_ext_mark_uninitialized(ex);
 			eh = path[depth].p_hdr;
 			nearex = ex;
 			goto merge;


