From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ext4: hook fiemap operation for directories
Date: Wed, 15 Apr 2009 20:09:03 +0530
Message-ID: <1239806343-14219-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40115 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbZDOOj1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 10:39:27 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3G1b9n6030515
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 11:37:09 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3FEdP0s438498
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 00:39:25 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3FEdOhl004764
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 00:39:25 +1000
In-Reply-To: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add fiemap callback for directories

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 22098e1..5e5e311 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2533,6 +2533,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.removexattr	= generic_removexattr,
 #endif
 	.permission	= ext4_permission,
+	.fiemap         = ext4_fiemap,
 };
 
 const struct inode_operations ext4_special_inode_operations = {
-- 
tg: (e60eece..) ext4_dir_fiemap (depends on: dir_fiemap)
