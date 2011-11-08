From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2: advance group in ext2fs_open2 during swapping
Date: Tue, 08 Nov 2011 16:26:35 -0600
Message-ID: <4EB9AC9B.5020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab1KHW0i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Nov 2011 17:26:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA8MQcGR005326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Nov 2011 17:26:38 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id pA8MQZHT022353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 8 Nov 2011 17:26:38 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Without this change, we go back to getting group descriptor
"0" each time we go around the "for i" loop.  It must properly
advance through the filesystem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I couldn't decipher the removed comment; maybe it was typed when
you thought you would do:

                        gdp = ext2fs_group_desc(fs, dest, j);

which would also work ... ?  It'd be clever, but I think my change
is more explicitly obvious.  Either way works.

We still have failing tests but at least nothing hangs now:
Tests failed: f_mmp f_mmp_garbage m_mmp t_mmp_1on t_mmp_2off 


diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 0cefe3f..40a52c5 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -356,8 +356,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 			goto cleanup;
 #ifdef WORDS_BIGENDIAN
 		for (j=0; j < groups_per_block; j++) {
-			/* The below happens to work... be careful. */
-			gdp = ext2fs_group_desc(fs, fs->group_desc, j);
+			gdp = ext2fs_group_desc(fs, fs->group_desc,
+						i * groups_per_block + j);
 			ext2fs_swap_group_desc2(fs, gdp);
 		}
 #endif

