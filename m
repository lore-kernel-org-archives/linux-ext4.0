From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 13/17] ext4: let ext4_find_entry handle inline data.
Date: Wed, 26 Oct 2011 15:34:24 +0800
Message-ID: <1319614468-11227-13-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Create a new ext4_find_inline_entry to handle the case
of inline data.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2c388ad..55498a8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -852,6 +852,29 @@ static inline int search_dirblock(struct buffer_head *bh,
 			  d_name, offset, res_dir);
 }
 
+static struct buffer_head *ext4_find_inline_entry(struct inode *dir,
+					const struct qstr *d_name,
+					struct ext4_dir_entry_2 **res_dir)
+{
+	int ret;
+	struct ext4_iloc iloc;
+	void *inline_start;
+	int inline_size;
+
+	if (ext4_get_inode_loc(dir, &iloc))
+		return NULL;
+
+	inline_start = ext4_get_inline_data_pos(dir, &iloc);
+	inline_size = ext4_get_max_inline_size(dir);
+
+	ret = search_dir(iloc.bh, inline_start, inline_size,
+			 dir, d_name, 0, res_dir);
+	if (ret == 1)
+		return iloc.bh;
+
+	brelse(iloc.bh);
+	return NULL;
+}
 
 /*
  *	ext4_find_entry()
@@ -887,6 +910,10 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	namelen = d_name->len;
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
+
+	if (ext4_has_inline_data(dir))
+		return ext4_find_inline_entry(dir, d_name, res_dir);
+
 	if ((namelen <= 2) && (name[0] == '.') &&
 	    (name[1] == '.' || name[1] == '\0')) {
 		/*
-- 
1.7.0.4
