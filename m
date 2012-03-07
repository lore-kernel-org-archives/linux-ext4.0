From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 35/54] mke2fs: Record the checksum algorithm in use in the
 superblock
Date: Tue, 06 Mar 2012 16:01:29 -0800
Message-ID: <20120307000129.11945.56042.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e31.co.us.ibm.com ([32.97.110.149]:34214 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031593Ab2CGADK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:03:10 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:03:09 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 16181C9005C
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:02:20 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2701ZbQ314690
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:01:43 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2701Y3S030372
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 21:01:35 -0300
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Record the type of checksum algorithm we're using for metadata in the
superblock when creating a filesystem.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 28485e3..92b80e9 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2422,6 +2422,10 @@ int main (int argc, char *argv[])
 			sizeof(fs->super->s_last_mounted));
 	}
 
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
+
 	if (!quiet || noaction)
 		show_stats(fs);
 

