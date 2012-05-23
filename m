From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] debugfs: fix strtoblk for 64bit block numbers
Date: Wed, 23 May 2012 18:01:14 -0500
Message-ID: <4FBD6C3A.1020301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2EWXBQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 May 2012 19:01:16 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4NN1GAL015975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 19:01:16 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4NN1EQM002983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 23 May 2012 19:01:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

# debugfs -R "icheck 4295032832" testimage
debugfs 1.42.3 (14-May-2012)
got block 4295032832 for 4295032832
got block 65536 for 4295032832
Block	Inode number
65536	<block not found>

Um, that's no good.

Affects icheck, freeb, setb, testb...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/util.c b/debugfs/util.c
index f43b470..b07a8cc 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -298,7 +298,7 @@ unsigned long long parse_ulonglong(const char *str, const char *cmd,
  */
 int strtoblk(const char *cmd, const char *str, blk64_t *ret)
 {
-	blk_t	blk;
+	blk64_t	blk;
 	int	err;
 
 	blk = parse_ulonglong(str, cmd, "block number", &err);

