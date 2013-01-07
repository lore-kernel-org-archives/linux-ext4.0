From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: show size requested when memory allocation fails
Date: Mon, 07 Jan 2013 15:45:54 -0600
Message-ID: <50EB4212.9080601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3AGVpz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jan 2013 16:45:55 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r07LjtWN019318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jan 2013 16:45:55 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r07LjsGl016000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 7 Jan 2013 16:45:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"e2fsck: Can't allocate dx_block info array"
is only so helpful - it'd be nice to know how much it tried to allocate.

In particular, since I think malloc(0) can return NULL,
it'd be nice to know if maybe we passed in an uninitialized (or
0-initialized) size.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/util.c b/e2fsck/util.c
index a808eec..6242954 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -121,7 +121,8 @@ void *e2fsck_allocate_memory(e2fsck_t ctx, unsigned int size,
 #endif
 	ret = malloc(size);
 	if (!ret) {
-		sprintf(buf, "Can't allocate %s\n", description);
+		sprintf(buf, "Can't allocate %u bytes for %s\n",
+			size, description);
 		fatal_error(ctx, buf);
 	}
 	memset(ret, 0, size);

