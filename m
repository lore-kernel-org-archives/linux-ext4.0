From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: use ALL_CFLAGS to build gen_crc32ctable
Date: Mon, 03 Oct 2011 11:14:15 -0500
Message-ID: <4E89DF57.90806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692Ab1JCQOP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 12:14:15 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p93GEFk1002304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Oct 2011 12:14:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p93GEEmp032444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 3 Oct 2011 12:14:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With just BUILD_CFLAGS this we don't get the right include
paths (i.e. within the tree) to build the gen_crc32ctable binary.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I think that the rule could probably be removed altogether, and
gen_crc32ctable.o would be built from gen_crc32ctable.c, and
the normal dependencies & rules would build gen_crc32ctable.
But this seems like the most obvious change.

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 3de9f87..07a0db18 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -413,7 +413,7 @@ $(OBJS): subdirs
 
 gen_crc32ctable: $(srcdir)/gen_crc32ctable.c
 	$(E) "	CC $@"
-	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32ctable \
+	$(Q) $(BUILD_CC) $(ALL_CFLAGS) -o gen_crc32ctable \
 		$(srcdir)/gen_crc32ctable.c
 
 crc32c_table.h: gen_crc32ctable

