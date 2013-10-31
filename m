From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove unreachable code in ext4_can_extents_be_merged()
Date: Thu, 31 Oct 2013 16:00:19 -0500
Message-ID: <5272C4E3.5040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3JaVAV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Oct 2013 17:00:21 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9VL0KTT008679
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 17:00:20 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r9VL0JHV030705
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 Oct 2013 17:00:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit
ec22ba8e ext4: disable merging of uninitialized extents

ensured that if either extent under consideration is uninit,
we decline to merge, and immediately return.

But right after that test, we test again for an uninit
extent; we can never hit this.  So just remove the impossible
test and associated variable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Disclosure: compile-tested only.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 54d52af..de6d467 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1666,7 +1666,7 @@ int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
-	unsigned short ext1_ee_len, ext2_ee_len, max_len;
+	unsigned short ext1_ee_len, ext2_ee_len;
 
 	/*
 	 * Make sure that both extents are initialized. We don't merge
@@ -1677,11 +1677,6 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
 		return 0;
 
-	if (ext4_ext_is_uninitialized(ex1))
-		max_len = EXT_UNINIT_MAX_LEN;
-	else
-		max_len = EXT_INIT_MAX_LEN;
