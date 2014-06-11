From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/3] mke2fs: add get_uint_from_profile to mke2fs.c
Date: Wed, 11 Jun 2014 08:37:54 +0000
Message-ID: <28989C0C9F1C0A428470D967B5FCED372A7E91@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:43315 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaFKInM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 04:43:12 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id s5B8hAqg016069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 17:43:10 +0900 (JST)
Content-Language: ja-JP
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can set flex_bg count only up to 2^30 with profile
because get_int_from_profile can handle it to 2^31-1.
Add get_uint_from_profile to read unsigned int value
so that mke2fs with profile can handle up to 2^31 flex_bg same as -G option.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
misc/mke2fs.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index b9145d1..88dc76c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1343,6 +1343,18 @@ int get_int_from_profile(char **types, const char *opt, int def_val)
 	return ret;
 }
 
+static unsigned int get_uint_from_profile(char **types, const char *opt,
+					unsigned int def_val)
+{
+	unsigned int ret;
+	char **cpp;
+
+	profile_get_uint(profile, "defaults", opt, 0, def_val, &ret);
+	for (cpp = types; *cpp; cpp++)
+		profile_get_uint(profile, "fs_types", *cpp, opt, ret, &ret);
+	return ret;
+}
+
 static double get_double_from_profile(char **types, const char *opt,
 				      double def_val)
 {
@@ -2278,7 +2290,7 @@ profile_error:
 		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
 	if (!flex_bg_size && (fs_param.s_feature_incompat &
 			      EXT4_FEATURE_INCOMPAT_FLEX_BG))
-		flex_bg_size = get_int_from_profile(fs_types,
+		flex_bg_size = get_uint_from_profile(fs_types,
 						    "flex_bg_size", 16);
 	if (flex_bg_size) {
 		if (!(fs_param.s_feature_incompat &
