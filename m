From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext4: avoid hang when mounting non-journal filesystems with orphan list
Date: Thu, 27 Dec 2012 01:43:15 -0500
Message-ID: <1356590595-23144-2-git-send-email-tytso@mit.edu>
References: <1356590595-23144-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1356590595-23144-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When trying to mount a file system which does not contain a journal,
but which does have a orphan list with an inode which needs to be
truncated, the mount call with hang forever in ext4_orphan_cleanup()
because ext4_orphan_del() will return immediately if no journal is
present.

This can be trivially reproduced by trying to mount the file system
found in tests/f_orphan_extents_inode/image.gz in the e2fsprogs
sources.  If a malicious user were to put this on a USB stick, and
mount it on a Linux desktop which automatically mounts newly inserted
USB sticks, this could be considered a potential denial of service
attack.  (Not a big deal in practice, but professional paranoids worry
about such things, and have even been known to allocate CVE numbers
on occasion.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index cac4482..8990165 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2648,7 +2648,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
-- 
1.7.12.rc0.22.gcdd159b
