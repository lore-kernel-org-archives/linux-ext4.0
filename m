From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] blkid: return cached info on either EPERM or EACCESS
Date: Tue, 27 May 2008 14:28:04 -0500
Message-ID: <483C60C4.6020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbYE0T2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2008 15:28:07 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4RJS62c020414
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 15:28:06 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RJS6Mb011830
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 15:28:06 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RJS49T018703
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2008 15:28:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is for RH bug #448591: blkid command does not work for unprivileged users

commit 838f133c72a583eae67414368e46ee0303e0a51f made it so that
any error except EPERM would flush cached filesystem info, but
if I run blkid as an unprivileged user on F9, I get EACCES not
EPERM; I think that in this case, as well, we should continue.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/blkid/probe.c
===================================================================
--- e2fsprogs.orig/lib/blkid/probe.c
+++ e2fsprogs/lib/blkid/probe.c
@@ -1155,7 +1155,7 @@ blkid_dev blkid_verify(blkid_cache cache
 	if (((probe.fd = open(dev->bid_name, O_RDONLY)) < 0) ||
 	    (fstat(probe.fd, &st) < 0)) {
 		if (probe.fd >= 0) close(probe.fd);
-		if (errno != EPERM) {
+		if (errno != EPERM && errno != EACCES) {
 			blkid_free_dev(dev);
 			return NULL;
 		}


