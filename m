From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring stable page
 writes
Date: Tue, 20 Nov 2012 18:00:56 -0800
Message-ID: <20121121020056.10225.15220.stgit@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext3 doesn't properly isolate pages from changes during writeback.  Since the
recommended fix is to use ext4, for now we'll just print a warning if the user
tries to mount in write mode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext3/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5366393..5b3725d 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 			"forcing read-only mode");
 		res = MS_RDONLY;
 	}
+	if (!read_only &&
+	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
+		ext3_msg(sb, KERN_ERR,
+			"error: ext3 cannot safely write data to a disk "
+			"requiring stable pages writes; forcing read-only "
+			"mode.  Upgrading to ext4 is recommended.");
+		res = MS_RDONLY;
+	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT3_VALID_FS))
