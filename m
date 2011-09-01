From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 36/37] e2p: Print superblock checksum in list_super
Date: Wed, 31 Aug 2011 17:39:02 -0700
Message-ID: <20110901003902.1176.58884.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44003 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab1IAAjJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:39:09 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810V7PI027339
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:31:07 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810d5aJ124472
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:39:05 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7VId2uR029480
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 12:39:04 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Displays superblock checksum when dumping superblock contents.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/e2p/ls.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index aa4a389..1c3ab1c 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -413,6 +413,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_grp_quota_inum)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		fprintf(f, "Checksum:                 0x%08x\n",
+			sb->s_checksum);
 }
 
 void list_super (struct ext2_super_block * s)

