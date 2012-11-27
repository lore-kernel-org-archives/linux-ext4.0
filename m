From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] tune2fs: respect quota config option
Date: Tue, 27 Nov 2012 12:35:48 -0600
Message-ID: <50B50804.6020309@redhat.com>
References: <50B504C4.6090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bert.Deknuydt@esat.kuleuven.be
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756357Ab2K0SgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 13:36:12 -0500
In-Reply-To: <50B504C4.6090504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we haven't turned --enable-quota on at config time,
I don't think tune2fs should know about the feature either.

Today we can actually tune2fs -O quota even if not
configured on, and then the rest of the tools will
refuse to touch it:

# tune2fs -O quota /dev/sda1
# tune2fs -O ^quota /dev/whatever complains
tune2fs 1.42.3 (14-May-2012)
tune2fs: Filesystem has unsupported read-only feature(s) while trying to open /dev/sda1
# fsck /dev/sda1
fsck from util-linux 2.21.2
e2fsck 1.42.3 (14-May-2012)
/dev/sda1 has unsupported feature(s): quota
e2fsck: Get a newer version of e2fsck!

Ok, so turn it off?
# tune2fs -O ^quota /dev/whatever complains
tune2fs 1.42.3 (14-May-2012)
tune2fs: Filesystem has unsupported read-only feature(s) while trying to open /dev/sda1

Nope.  Debugfs?  Nope.

# debugfs -w /dev/sda1
debugfs 1.42.3 (14-May-2012)
/dev/sda1: Filesystem has unsupported read-only feature(s) while opening filesystem

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Bert DeKnuydt <Bert.Deknuydt@esat.kuleuven.be>
Addresses-Red-Hat-Bugzilla: #880596
---

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b290c46..17c1565 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -145,7 +145,9 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
+#ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
+#endif
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 
@@ -164,7 +166,9 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
 		EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+#ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
+#endif
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
 };
 


