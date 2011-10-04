From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: Fix up usage & error text for cluster size specification
Date: Tue, 04 Oct 2011 17:12:11 -0500
Message-ID: <4E8B84BB.6040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab1JDWMW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 18:12:22 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p94MCMAF007954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 18:12:22 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p94MCEOC020740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 Oct 2011 18:12:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit c6ed60cd removed "f" (fragment size) from the getopt string,
and re-used its spot in the getopt switch, but didn't update the
usage message or the error message during parsing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index c439e37..0a50f3a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -113,7 +113,7 @@ int linux_version_code = 0;
 static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
-	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
+	"[-C cluster-size]\n\t[-i bytes-per-inode] [-I inode-size] "
 	"[-J journal-options]\n"
 	"\t[-G meta group size] [-N number-of-inodes]\n"
 	"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
@@ -1324,7 +1324,7 @@ profile_error:
 			if (cluster_size < EXT2_MIN_CLUSTER_SIZE ||
 			    cluster_size > EXT2_MAX_CLUSTER_SIZE || *tmp) {
 				com_err(program_name, 0,
-					_("invalid fragment size - %s"),
+					_("invalid cluster size - %s"),
 					optarg);
 				exit(1);
 			}

