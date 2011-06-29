From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] mke2fs: Document stripe_width, not stripe-width
Date: Wed, 29 Jun 2011 10:47:40 -0600
Message-ID: <1309366060-25985-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60493 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab1F2Qro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2011 12:47:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For consistency with other multi-word options, document the extended
option stripe_width instead of stripe-width.  This also avoids the
complexity of parsing options that have an embedded '-'.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 misc/mke2fs.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 0d4b046..6901497 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -209,7 +209,7 @@ This mostly affects placement of filesystem metadata like bitmaps at
 time to avoid placing them on a single disk, which can hurt performance.
 It may also be used by the block allocator.
 .TP
-.BI stripe-width= stripe-width
+.BI stripe_width= stripe-width
 Configure the filesystem for a RAID array with
 .I stripe-width
 filesystem blocks per stripe. This is typically stride-size * N, where
-- 
1.7.3.4

