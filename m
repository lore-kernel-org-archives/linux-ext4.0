From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 14/23] richacl: Disable automatic inheritance with posix mapped acls
Date: Mon,  1 Feb 2010 11:04:56 +0530
Message-ID: <1265002505-8387-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org
To: sfrench@us.ibm.com, ffilz@us.ibm.com, agruen@suse.de,
	adilger@sun.com, sandeen@redhat.com, tytso@mit.edu,
	staubach@redhat.com, bfields@citi.umich.edu, jlayton@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60717 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0BAFfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Feb 2010 00:35:23 -0500
In-Reply-To: <1265002505-8387-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/richacl_posix.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/richacl_posix.c b/fs/richacl_posix.c
index 437d3ac..ae49106 100644
--- a/fs/richacl_posix.c
+++ b/fs/richacl_posix.c
@@ -191,6 +191,12 @@ static void posix_to_richacl(struct posix_acl *pacl, int type,
 	 */
 	acl->a_flags |= ACL4_POSIX_MAPPED;
 
+	/*
+	 * Mark the acl as ACL4_PROTECTED so that we don't
+	 * do automatic inheritance with posix mapped acls
+	 */
+	acl->a_flags |= ACL4_PROTECTED;
+
 	return;
 }
 
-- 
1.7.0.rc0.48.gdace5

