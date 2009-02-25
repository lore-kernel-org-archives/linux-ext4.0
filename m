From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: blkid.static make target
Date: Tue, 24 Feb 2009 23:15:33 -0600
Message-ID: <49A4D3F5.3000106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZBYFPg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 00:15:36 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1P5FZt0011466
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:15:35 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1P5FZ1N020140
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:15:35 -0500
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1P5FYKu008769
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 00:15:35 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nice for testing w/o needing to swizzle around system 
libraries...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/misc/Makefile
===================================================================
--- e2fsprogs.orig/misc/Makefile
+++ e2fsprogs/misc/Makefile
@@ -370,6 +370,11 @@ blkid: $(BLKID_OBJS) $(DEPLIBBLKID) $(LI
 	@$(CC) $(ALL_LDFLAGS) -o blkid $(BLKID_OBJS) $(LIBBLKID) $(LIBINTL) \
 		$(LIBEXT2FS)
 
+blkid.static: $(BLKID_OBJS) $(STATIC_DEPLIBS) $(DEPSTATIC_LIBBLKID)
+	@echo "	LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o blkid.static $(BLKID_OBJS) $(STATIC_LIBS) \
+		$(STATIC_LIBBLKID) $(LIBINTL)
+
 blkid.profiled: $(PROFILED_BLKID_OBJS) $(DEPPROFILED_LIBBLKID) \
 		$(PROFILED_LIBEXT2FS)
 	@echo "	LD $@"

