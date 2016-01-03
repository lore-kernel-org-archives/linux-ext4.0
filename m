From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH 2/2] security: use XATTR_*_PREFIX_LEN instead sizeof(...)
Date: Sun,  3 Jan 2016 20:56:38 +0100
Message-ID: <1451850998-28639-2-git-send-email-toralf.foerster@gmx.de>
References: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451850998-28639-1-git-send-email-toralf.foerster@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

use the definition in include/uapi/linux/xattr.h

igned-off-by: Toralf F=C3=B6rster <toralf.foerster@gmx.de>
---
 security/commoncap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 1832cf7..907a3ef 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -658,7 +658,7 @@ int cap_inode_setxattr(struct dentry *dentry, const=
 char *name,
 	}
=20
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
+		     XATTR_SECURITY_PREFIX_LEN) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
@@ -684,7 +684,7 @@ int cap_inode_removexattr(struct dentry *dentry, co=
nst char *name)
 	}
=20
 	if (!strncmp(name, XATTR_SECURITY_PREFIX,
-		     sizeof(XATTR_SECURITY_PREFIX) - 1) &&
+		     XATTR_SECURITY_PREFIX_LEN) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
--=20
2.4.10
