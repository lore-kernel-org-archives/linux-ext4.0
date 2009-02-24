From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix potential null ptr defef in check_for_modules()
Date: Tue, 24 Feb 2009 15:13:39 -0600
Message-ID: <49A46303.7070405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175AbZBXVNn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 16:13:43 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n1OLDgdq010698
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 16:13:42 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1OLDgms019428
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 16:13:42 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n1OLDfNg030542
	for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 16:13:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The coverity scanner found this one.

If a line in modules.dep has a ":" but no "/" then:

                if ((cp = strchr(buf, ':')) != NULL)
                        *cp = 0;
                else
                        continue;
                if ((cp = strrchr(buf, '/')) != NULL)
                        cp++;
                /* XXX else cp is still null */
                i = strlen(cp);

... we will deref a null pointer (cp).  This can be 
demonstrated by putting a line like:

foo.ko:

into modules.dep.  The below change just says that if no "/" is
found, treat the whole string as the module name.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/e2fsck/util.c
===================================================================
--- e2fsprogs.orig/e2fsck/util.c
+++ e2fsprogs/e2fsck/util.c
@@ -663,6 +663,8 @@ int check_for_modules(const char *fs_nam
 			continue;
 		if ((cp = strrchr(buf, '/')) != NULL)
 			cp++;
+		else
+			cp = buf;
 		i = strlen(cp);
 		if (i > 3) {
 			t = cp + i - 3;
Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c
+++ e2fsprogs/lib/blkid/probe.c
@@ -227,6 +227,8 @@ static int check_for_modules(const char 
 			continue;
 		if ((cp = strrchr(buf, '/')) != NULL)
 			cp++;
+		else
+			cp = buf;
 		i = strlen(cp);
 		if (i > 3) {
 			t = cp + i - 3;

