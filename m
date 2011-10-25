From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: use ext4_reserve_inode_write in ext4_xattr_set_handle
Date: Tue, 25 Oct 2011 12:52:09 -0500
Message-ID: <4EA6F749.3000308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1JYRwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 13:52:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9PHqAbX032609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2011 13:52:10 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p9PHq95P016265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2011 13:52:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_mark_iloc_dirty() says:

 * The caller must have previously called ext4_reserve_inode_write().
 * Give this, we know that the caller already has write access to iloc->bh.

ext4_xattr_set_handle, however, just open-codes it.  May as well use
the helper function for consistency.

No bug here, just tidiness.

(Note: on cleanup path, ext4_reserve_inode_write sets
the bh to NULL if it returns an error, and brelse() of 
a null bh is handled gracefully).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..eefbdb0 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -985,11 +985,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	no_expand = ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 
-	error = ext4_get_inode_loc(inode, &is.iloc);
-	if (error)
-		goto cleanup;
