From: Stratos Karafotis <stratosk@semaphore.gr>
Subject: [PATCH linux-next] ext4: inode: Fix compiler warning
Date: Wed, 05 Jun 2013 22:24:41 +0300
Message-ID: <51AF9079.90304@semaphore.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

=46ix the following compiler warning:

fs/ext4/inode.c: In function =91ext4_da_writepages=92:
fs/ext4/inode.c:2212:6: warning: =91err=92 may be used uninitialized in=
 this
function [-Wmaybe-uninitialized]
fs/ext4/inode.c:2155:6: note: =91err=92 was declared here

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 442c5d2..702428c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2152,7 +2152,7 @@ static int mpage_map_and_submit_extent(handle_t *=
handle,
 {
 	struct inode *inode =3D mpd->inode;
 	struct ext4_map_blocks *map =3D &mpd->map;
-	int err;
+	int err =3D 0;
 	loff_t disksize;
=20
 	mpd->io_submit.io_end->offset =3D
--=20
1.8.1.4
