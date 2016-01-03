From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH 1/2] ext4: use XATTR_*_PREFIX_LEN instead sizeof(...)
Date: Sun,  3 Jan 2016 20:56:37 +0100
Message-ID: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50842 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbcACT4m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jan 2016 14:56:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

use the definition in include/uapi/linux/xattr.h

Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 fs/ext4/xattr_security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr_security.c b/fs/ext4/xattr_security.c
index 36f4c1a..1a3d629 100644
--- a/fs/ext4/xattr_security.c
+++ b/fs/ext4/xattr_security.c
@@ -16,7 +16,7 @@ ext4_xattr_security_list(const struct xattr_handler *=
handler,
 			 struct dentry *dentry, char *list, size_t list_size,
 			 const char *name, size_t name_len)
 {
-	const size_t prefix_len =3D sizeof(XATTR_SECURITY_PREFIX)-1;
+	const size_t prefix_len =3D XATTR_SECURITY_PREFIX_LEN;
 	const size_t total_len =3D prefix_len + name_len + 1;
=20
=20
--=20
2.4.10

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
