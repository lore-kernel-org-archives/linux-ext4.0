From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 54/54] mke2fs: Enable metadata_csum on ext4dev filesystems
Date: Tue, 06 Mar 2012 16:03:44 -0800
Message-ID: <20120307000344.11945.47813.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e35.co.us.ibm.com ([32.97.110.153]:41098 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031610Ab2CGAEe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:04:34 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:04:32 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 4F4961FF0048
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 17:03:59 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2703vvX130372
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:03:58 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2703qKW007257
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:03:53 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enable full-power metadata checksumming by default on 'ext4dev' filesystems.
This should be fairly safe for now, since only developers should be using this
new feature.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 misc/mke2fs.conf |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index 0871f77..178733f 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -16,7 +16,7 @@
 		inode_size = 256
 	}
 	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
 		inode_size = 256
 		options = test_fs=1
 	}

