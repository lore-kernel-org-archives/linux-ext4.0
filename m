From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 08/21] fs: Mark function as static in ext3/dir.c
Date: Sun, 9 Feb 2014 18:36:27 +0530
Message-ID: <999693f220bb65e2a07c4450548d99ea3ceac9d2.1391949868.git.rashika.kheria@gmail.com>
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

Mark function as static in ext3/dir.c because it is not used outside
this file.

This also eliminates the following warning in ext3/dir.c:
fs/ext3/dir.c:278:8: warning: no previous prototype for =E2=80=98ext3_d=
ir_llseek=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ext3/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index e66e480..17742ee 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -275,7 +275,7 @@ static inline loff_t ext3_get_htree_eof(struct file=
 *filp)
  * NOTE: offsets obtained *before* ext3_set_inode_flag(dir, EXT3_INODE=
_INDEX)
  *       will be invalid once the directory was converted into a dx di=
rectory
  */
-loff_t ext3_dir_llseek(struct file *file, loff_t offset, int whence)
+static loff_t ext3_dir_llseek(struct file *file, loff_t offset, int wh=
ence)
 {
 	struct inode *inode =3D file->f_mapping->host;
 	int dx_dir =3D is_dx_dir(inode);
--=20
1.7.9.5
