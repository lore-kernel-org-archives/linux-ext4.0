From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2] ext4:Let ext4_ext_fiemap_cb() handle blocks before request range correctly.
Date: Tue, 10 May 2011 22:06:06 +0800
Message-ID: <1305036366-1228-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53651 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab1EJOFv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 10:05:51 -0400
Received: by pzk9 with SMTP id 9so2832236pzk.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 07:05:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

v1->v2:
  Add more specific description.

To get delayed-extent information, ext4_ext_fiemap_cb() lookups pagecache,
it thus collects information starting from a page's head block.
If blockszie < pagesize, the beginning blocks of a page may lie before the
range.  ext4_ext_fiemap_cb() should proceed ignoring them, because they
has been handled before.

Reported-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..ec37109 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3718,9 +3718,14 @@ out:
 
 			bh = head;
 			do {
+				if (end < newex->ec_block)
+					/* The buffer is not in
+					 * the request range.
+					 */
+					continue;
 				if (buffer_mapped(bh)) {
 					/* get the 1st mapped buffer. */
-					if (end > newex->ec_block +
+					if (end >= newex->ec_block +
 						newex->ec_len)
 						/* The buffer is out of
 						 * the request range.
-- 
1.7.5.1

