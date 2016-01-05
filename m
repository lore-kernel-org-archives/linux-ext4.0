From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH 1/2] ext4: use XATTR_*_PREFIX_LEN instead sizeof(...)
Date: Tue,  5 Jan 2016 18:49:41 +0100
Message-ID: <1452016181-7883-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, jack@suse.cz,
	=?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

use the definition in include/uapi/linux/xattr.h

Signed-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>

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
