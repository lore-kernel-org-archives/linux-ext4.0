From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 36/50] mke2fs: Record the checksum algorithm in use in the
	superblock
Date: Mon, 28 Nov 2011 16:32:05 -0800
Message-ID: <20111129003205.17953.45558.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e33.co.us.ibm.com ([32.97.110.151]:39036 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1K2AcL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:32:11 -0500
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:32:10 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0W9rm035870
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:32:09 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0W7sL016031
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:32:09 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Record the type of checksum algorithm we're using for metadata in the
superblock when creating a filesystem.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 98af8b0..ba7625d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2418,6 +2418,10 @@ int main (int argc, char *argv[])
 			sizeof(fs->super->s_last_mounted));
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
+
 	if (!quiet || noaction)
 		show_stats(fs);
 

