From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4:Fix a bug in 6d9c85eb.
Date: Tue, 10 May 2011 19:31:57 +0800
Message-ID: <1305027117-936-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49468 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1EJLbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 07:31:47 -0400
Received: by pvg12 with SMTP id 12so2780111pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 04:31:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In case blocksize < pagesize, ext4_ext_fiemap_cb need to ignore
blocks which are not in request range.

BUG description:
xfstests 225 ended in a endless loop without this patch
when blocksize < pagesize.

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

