Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46014 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeKUKe0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:34:26 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v2 7/8] tune2fs: Prevent enabling encryption flag on encoding-aware fs
Date: Tue, 20 Nov 2018 19:02:05 -0500
Message-Id: <20181121000206.15496-8-krisman@collabora.com>
In-Reply-To: <20181121000206.15496-1-krisman@collabora.com>
References: <20181121000206.15496-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

The kernel will refuse to mount filesystems with the encryption and
encoding features enabled at the same time.  The encoding feature can
only be set at mount time, so we can just prevent encryption from being
set at a later time by tune2fs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 misc/tune2fs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a680b461cc86..4c92bee30b38 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1459,6 +1459,12 @@ mmp_error:
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
+		if (ext2fs_has_feature_fname_encoding(sb)) {
+			fputs(_("Cannot enable encrypt feature on filesystems "
+				"with the encoding feature enabled.\n"),
+			      stderr);
+			return 1;
+		}
 		fs->super->s_encrypt_algos[0] =
 			EXT4_ENCRYPTION_MODE_AES_256_XTS;
 		fs->super->s_encrypt_algos[1] =
-- 
2.19.1
