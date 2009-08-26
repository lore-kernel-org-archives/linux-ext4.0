From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Allow rename even if link count is greater than EXT4_LINK_MAX for index directories
Date: Wed, 26 Aug 2009 17:07:25 +0530
Message-ID: <1251286645-14439-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51315 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZHZLh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 07:37:27 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.14.3/8.13.1) with ESMTP id n7QBbRJZ001156
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 21:37:27 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7QBbSAS1339400
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 21:37:28 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7QBbR9Z004927
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 21:37:28 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With EXT4_FEATURE_RO_COMPAT_DIR_NLINK we enable more than EXT4_LINK_MAX
sub directories. So we should not fail rename with too many links error
if EXT4_FEATURE_RO_COMPAT_DIR_NLINK feature is set.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index de04013..9d0db97 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2413,7 +2413,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 		retval = -EMLINK;
 		if (!new_inode && new_dir != old_dir &&
-				new_dir->i_nlink >= EXT4_LINK_MAX)
+					EXT4_DIR_LINK_MAX(new_dir))
 			goto end_rename;
 	}
 	if (!new_bh) {
-- 
1.6.4.1.196.g31f0b

