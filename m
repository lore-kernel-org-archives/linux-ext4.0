Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39058 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfANUkV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2019 15:40:21 -0500
From: Mathieu Malaterre <malat@debian.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ext4: annotate implicit fall throughs
Date: Mon, 14 Jan 2019 21:39:43 +0100
Message-Id: <20190114203945.20233-1-malat@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a plan to build the kernel with -Wimplicit-fallthrough and
these places in the code produced warnings (W=1). Fix them up.

This commit remove the following warnings:

  fs/ext4/hash.c:233:15: warning: this statement may fall through [-Wimplicit-fallthrough=]
  fs/ext4/hash.c:246:15: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
 fs/ext4/hash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index e22dcfab308b..46b24da33a28 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -231,6 +231,7 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 		break;
 	case DX_HASH_HALF_MD4_UNSIGNED:
 		str2hashbuf = str2hashbuf_unsigned;
+		/* fall through */
 	case DX_HASH_HALF_MD4:
 		p = name;
 		while (len > 0) {
@@ -244,6 +245,7 @@ int ext4fs_dirhash(const char *name, int len, struct dx_hash_info *hinfo)
 		break;
 	case DX_HASH_TEA_UNSIGNED:
 		str2hashbuf = str2hashbuf_unsigned;
+		/* fall through */
 	case DX_HASH_TEA:
 		p = name;
 		while (len > 0) {
-- 
2.19.2
