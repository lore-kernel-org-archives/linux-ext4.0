From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] e2fsprogs: Document mmp commands in debugfs manpage
Date: Thu, 10 Nov 2011 16:51:28 -0600
Message-ID: <4EBC5570.3060708@redhat.com>
References: <4EBC5524.3000105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1KJWva (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 17:51:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAAMpT9j029163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 17:51:30 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pAAMpSwg002127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 17:51:29 -0500
In-Reply-To: <4EBC5524.3000105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Document the dump_mmp and set_mmp_value commands in
the debugfs manpage.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index fe07f34..d0d1938 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -210,6 +210,9 @@ option is given set the owner, group and permissions information on
 to match 
 .IR filespec .
 .TP
+.I dump_mmp
+Display the multiple-mount protection (mmp) field values.
+.TP
 .I dx_hash [-h hash_alg] [-s hash_seed] filename
 Calculate the directory hash of
 .IR filename .
@@ -485,6 +488,16 @@ The list of valid inode fields which can be set via this command
 can be displayed by using the command:
 .B set_inode_field -l
 .TP
+.I set_mmp_value field value
+Modify the multiple-mount protection (mmp) data so that the 
+mmp field
+.I field
+has value
+.I value.
+The list of valid mmp fields which can be set via this command
+can be displayed by using the command:
+.B set_mmp_value -l
+.TP
 .I set_super_value field value
 Set the superblock field
 .I field


