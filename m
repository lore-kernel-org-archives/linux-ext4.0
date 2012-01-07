From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 35/51] mke2fs: Record the checksum algorithm in use in the
	superblock
Date: Sat, 07 Jan 2012 00:36:40 -0800
Message-ID: <20120107083640.25788.24598.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58832 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369Ab2AGIgt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:36:49 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:36:48 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078aitO308352
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:36:44 -0500
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078agT6026534
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:36:43 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Record the type of checksum algorithm we're using for metadata in the
superblock when creating a filesystem.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7888a2f..14c047a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2419,6 +2419,10 @@ int main (int argc, char *argv[])
 			sizeof(fs->super->s_last_mounted));
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
+
 	if (!quiet || noaction)
 		show_stats(fs);
 

