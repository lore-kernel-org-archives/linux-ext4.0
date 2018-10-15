Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37512 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbeJPE74 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Oct 2018 00:59:56 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH e2fsprogs 9/9] tune2fs: Prevent enabling encryption flag on encoding-aware fs
Date: Mon, 15 Oct 2018 17:12:20 -0400
Message-Id: <20181015211220.27370-10-krisman@collabora.co.uk>
In-Reply-To: <20181015211220.27370-1-krisman@collabora.co.uk>
References: <20181015211220.27370-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The kernel will refuse to mount filesystems with the encryption and
encoding features enabled at the same time.  The encoding feature can
only be set at mount time, so we can just prevent encryption from being
set at a later time by tune2fs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 misc/tune2fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a680b461cc86..cda4d8076f81 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1459,6 +1459,12 @@ mmp_error:
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
+		if (ext2fs_has_feature_fname_encoding(sb)) {
+			fputs(_("Cannot enable feature 'encrypt' on filesystems "
+				"with the 'encoding' feature enabled.\n"),
+			      stderr);
+			return 1;
+		}
 		fs->super->s_encrypt_algos[0] =
 			EXT4_ENCRYPTION_MODE_AES_256_XTS;
 		fs->super->s_encrypt_algos[1] =
-- 
2.19.1
