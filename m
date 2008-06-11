From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] ext4: fix build failure if DX_DEBUG
Date: Wed, 11 Jun 2008 16:43:28 +0800
Message-ID: <484F9030.2020800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49269 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYFKIpF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 04:45:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I got build failure when I turned on DX_DEBUG.

fs/ext4/namei.c: In function =E2=80=98dx_show_leaf=E2=80=99:
fs/ext4/namei.c:291: error: implicit declaration of function =E2=80=98e=
xt4_next_entry=E2=80=99
fs/ext4/namei.c:291: warning: assignment makes pointer from integer wit=
hout a cast

Move the definition of ext4_next_entry() upwards just as ext3 code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ext4/namei.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ab16bea..4315fd7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -183,6 +183,16 @@ static int ext4_dx_add_entry(handle_t *handle, str=
uct dentry *dentry,
 			     struct inode *inode);
=20
 /*
+ * p is at least 6 bytes before the end of page
+ */
+static inline struct ext4_dir_entry_2 *
+ext4_next_entry(struct ext4_dir_entry_2 *p)
+{
+	return (struct ext4_dir_entry_2 *)((char *)p +
+		ext4_rec_len_from_disk(p->rec_len));
+}
+
+/*
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
@@ -554,15 +564,6 @@ static int ext4_htree_next_block(struct inode *dir=
, __u32 hash,
=20
=20
 /*
- * p is at least 6 bytes before the end of page
- */
-static inline struct ext4_dir_entry_2 *ext4_next_entry(struct ext4_dir=
_entry_2 *p)
-{
-	return (struct ext4_dir_entry_2 *)((char *)p +
-		ext4_rec_len_from_disk(p->rec_len));
-}
