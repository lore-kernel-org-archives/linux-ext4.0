From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 09/21] fs: Mark function as static in ext3/xattr_security.c
Date: Sun, 9 Feb 2014 18:39:11 +0530
Message-ID: <bcf66d9631e4094a46e539950331f79289e4d85a.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, josh@joshtriplett.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mark function as static in ext3/xattr_security.c because it is not used
outside this file.

This eliminates the following warning in ext3/xattr_security.c:
fs/ext3/xattr_security.c:46:5: warning: no previous prototype for =E2=80=
=98ext3_initxattrs=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ext3/xattr_security.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/xattr_security.c b/fs/ext3/xattr_security.c
index 3387664..722c2bf 100644
--- a/fs/ext3/xattr_security.c
+++ b/fs/ext3/xattr_security.c
@@ -43,8 +43,9 @@ ext3_xattr_security_set(struct dentry *dentry, const =
char *name,
 			      name, value, size, flags);
 }
=20
-int ext3_initxattrs(struct inode *inode, const struct xattr *xattr_arr=
ay,
-		    void *fs_info)
+static int ext3_initxattrs(struct inode *inode,
+			   const struct xattr *xattr_array,
+			   void *fs_info)
 {
 	const struct xattr *xattr;
 	handle_t *handle =3D fs_info;
--=20
1.7.9.5
