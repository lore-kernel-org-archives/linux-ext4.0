From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/54] debugfs: fix crash in ea_set argument handling
Date: Mon, 26 Jan 2015 23:35:53 -0800
Message-ID: <20150127073553.13308.85045.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45099 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbbA0Hf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:35:58 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix an incorrect check in ea_set that would crash debugfs if someone
runs 'ea_set / foo.bar' (i.e. with no value argument)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/xattrs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index a80fd0b..e71bc15 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -202,7 +202,7 @@ void do_set_xattr(int argc, char **argv)
 		}
 	}
 
-	if (optind != argc - 2 && optind != argc - 3) {
+	if (!(fp && optind == argc - 2) && !(!fp && optind == argc - 3)) {
 		printf("%s: Usage: %s <file> <attr> [-f infile | value>]\n",
 		       argv[0], argv[0]);
 		goto out2;

