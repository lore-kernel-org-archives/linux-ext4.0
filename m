From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 07/21] fs: Mark function as static in ext2/xattr_security.c
Date: Sun, 9 Feb 2014 18:34:10 +0530
Message-ID: <5db9dc03c6c316665e9fd1c6253e9c29ab3a39cf.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	josh@joshtriplett.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mark function as static in ext2/xattr_security.c because it is not
used outside this file.

This also elimiantes the following warning in ext2/xattr_security.c:
fs/ext2/xattr_security.c:45:5: warning: no previous prototype for =E2=80=
=98ext2_initxattrs=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ext2/xattr_security.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/xattr_security.c b/fs/ext2/xattr_security.c
index cfedb2c..c0ebc4d 100644
--- a/fs/ext2/xattr_security.c
+++ b/fs/ext2/xattr_security.c
@@ -42,8 +42,8 @@ ext2_xattr_security_set(struct dentry *dentry, const =
char *name,
 			      value, size, flags);
 }
=20
-int ext2_initxattrs(struct inode *inode, const struct xattr *xattr_arr=
ay,
-		    void *fs_info)
+static int ext2_initxattrs(struct inode *inode, const struct xattr *xa=
ttr_array,
+			   void *fs_info)
 {
 	const struct xattr *xattr;
 	int err =3D 0;
--=20
1.7.9.5
