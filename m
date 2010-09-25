From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sat, 25 Sep 2010 14:31:52 -0400
Message-ID: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0IYScc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Sep 2010 14:32:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tracey Dent <Tdent48227@gmail.com>

Found and corrected indent issue using checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/acl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 5e2ed45..16d39e3 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -27,7 +27,7 @@ ext4_acl_from_disk(const void *value, size_t size)
 	if (!value)
 		return NULL;
 	if (size < sizeof(ext4_acl_header))
-		 return ERR_PTR(-EINVAL);
+		return ERR_PTR(-EINVAL);
 	if (((ext4_acl_header *)value)->a_version !=
 	    cpu_to_le32(EXT4_ACL_VERSION))
 		return ERR_PTR(-EINVAL);
-- 
1.7.3

