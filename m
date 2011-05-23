From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/3] Ext4: handle SEEK_HOLE/SEEK_DATA generically V4
Date: Mon, 23 May 2011 17:43:11 -0400
Message-ID: <1306186991-1905-3-git-send-email-josef@redhat.com>
References: <1306186991-1905-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sunil.mushran@oracle.com, viro@ZenIV.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306186991-1905-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since Ext4 has its own lseek we need to make sure it handles
SEEK_HOLE/SEEK_DATA.  For now just do the same thing that is done in the generic
case, somebody else can come along and make it do fancy things later.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V3->V4:
-update to work the same as the generic way
 fs/ext4/file.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 7b80d54..148270e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -236,6 +236,27 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 		}
 		offset += file->f_pos;
 		break;
+	case SEEK_DATA:
+		/*
+		 * In the generic case the entire file is data, so as long as
+		 * offset isn't at the end of the file then the offset is data.
+		 */
+		if (offset >= inode->i_size) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		break;
+	case SEEK_HOLE:
+		/*
+		 * There is a virtual hole at the end of the file, so as long as
+		 * offset isn't i_size or larger, return i_size.
+		 */
+		if (offset >= inode->i_size) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+		offset = inode->i_size;
+		break;
 	}
 
 	if (offset < 0 || offset > maxbytes) {
-- 
1.7.2.3
