From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: use ext2fs_open_file() in check_plausibility()
Date: Wed, 21 May 2014 12:35:29 -0500
Message-ID: <537CE3E1.10406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaEURf3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2014 13:35:29 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4LHZTdY006451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2014 13:35:29 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4LHZSfu011149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2014 13:35:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit:

802146c mke2fs: create a regular file if necessary

caused a regression on 32-bit machines; the open() fails if
the file size is > 4G.

Using ext2fs_open_file() fixes it.

Resolves: Red Hat Bugzilla #1099892

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

TBH I don't know if this should be using ext2fs_open_file(),
or some other magic like O_LARGEFILE, but this works for me,
and we use the stat/fstat wrapper here too, so ...

diff --git a/misc/util.c b/misc/util.c
index f85942e..d638625 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -94,7 +94,7 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	if (flags & CREATE_FILE)
 		fl |= O_CREAT;
 
-	fd = open(device, fl, 0666);
+	fd = ext2fs_open_file(device, fl, 0666);
 	if (fd < 0) {
 		fprintf(stderr, _("Could not open %s: %s\n"),
 			device, error_message(errno));


