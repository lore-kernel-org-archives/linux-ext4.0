From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 35/47] mke2fs: Record the checksum algorithm in use in the
	superblock
Date: Sat, 08 Oct 2011 00:37:00 -0700
Message-ID: <20111008073659.17888.31441.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e38.co.us.ibm.com ([32.97.110.159]:51988 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1JHHjk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:39:40 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987SkWS002556
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:28:46 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987b2PH168810
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:02 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987b1TX017050
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:02 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Record the type of checksum algorithm we're using for metadata in the
superblock when creating a filesystem.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6e9f399..45bab5c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2398,6 +2398,10 @@ int main (int argc, char *argv[])
 			sizeof(fs->super->s_last_mounted));
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
+
 	if (!quiet || noaction)
 		show_stats(fs);
 

