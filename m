From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation bug
Date: Mon, 31 Mar 2014 21:16:49 +0800
Message-ID: <53396AC1.10108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	gxt@mprc.pku.edu.cn
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

'0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
append 'ULL' for it.

The related warning (with allmodconfig under unicore32):

    CC [M]  fs/ext4/extents_status.o
  fs/ext4/extents_status.c: In function =91__es_remove_extent=92:
  fs/ext4/extents_status.c:813: warning: integer constant is too large =
for =91long=92 type


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 fs/ext4/extents_status.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 0a014a7..0ebc212 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -810,7 +810,7 @@ retry:
=20
 			newes.es_lblk =3D end + 1;
 			newes.es_len =3D len2;
-			block =3D 0x7FDEADBEEF;
+			block =3D 0x7FDEADBEEFULL;
 			if (ext4_es_is_written(&orig_es) ||
 			    ext4_es_is_unwritten(&orig_es))
 				block =3D ext4_es_pblock(&orig_es) +
--=20
1.7.9.5
