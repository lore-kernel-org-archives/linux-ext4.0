From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 12:21:58 -0600
Message-ID: <4D5C15C6.5000802@redhat.com>
References: <4D5C1380.2020602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1BPSV7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 13:21:59 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GILxGM007029
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 13:21:59 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GILwwo014272
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Feb 2011 13:21:59 -0500
In-Reply-To: <4D5C1380.2020602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

User namespace xattrs are generally useful, and I think extN
is the only filesystem requiring a special mount option to
enable them, when xattrs are otherwise available.  So this
change sets that mount option into the defaults.

Note that if xattrs are config'd off, this will lead to a
mostly-harmless:

   EXT4-fs (sdc1): (no)user_xattr options not supported

message at mount time... 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index ff63a92..12a9452 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -164,6 +164,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	set_field(s_log_groups_per_flex, 0);
 	set_field(s_flags, 0);
+	set_field(s_default_mount_opts, EXT2_DEFM_XATTR_USER);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;

