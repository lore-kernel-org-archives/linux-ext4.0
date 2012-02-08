From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: recognize mke4fs program name
Date: Wed, 08 Feb 2012 14:56:19 -0600
Message-ID: <4F32E173.2050103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2BHU4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Feb 2012 15:56:20 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q18KuKrY015078
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 8 Feb 2012 15:56:20 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q18KuJnM006082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 8 Feb 2012 15:56:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We shipped "mke4fs" alongside mke2fs in RHEL5, so that ext4-capable
utilities could be installed without disturbing the venerable e2fsprogs-1.39
shipped in RHEL5 from the beginning.  But it surprised some users that
"mke4fs" created ext2 filesystems by default rather than ext4.
While it was my intent to have the renamed binaries behave exactly
like the stock ones, it seems that there is some precedence for
handling "mkeNfs" in the code, so seems reasonable to add 
mke4fs -> ext4 as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This probably doesn't matter much to upstream, but it seems consistent
with the existing code, below, if you'd like to include it.


diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e97e44e..410f880 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1014,6 +1014,8 @@ static char **parse_fs_type(const char *fs_type,
 		ext_type = "ext2";
 	else if (!strcmp(program_name, "mke3fs"))
 		ext_type = "ext3";
+	else if (!strcmp(program_name, "mke4fs"))
+		ext_type = "ext4";
 	else if (progname) {
 		ext_type = strrchr(progname, '/');
 		if (ext_type)

