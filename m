From: Coly Li <coyli@suse.de>
Subject: [PATCH] e2fsprogs: add directory inode reservation option to mke2fs.8
Date: Tue, 30 Oct 2007 01:05:36 +0800
Message-ID: <472612E0.9080204@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34206 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbXJ2REk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Oct 2007 13:04:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds explaining for directory inode reservation option to mke2fs.8. Ask for review.

Signed-off-by: Coly Li <coyli@suse.de>
---
 misc/mke2fs.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index a3dc4a1..9379cd4 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -187,6 +187,9 @@ filesystem blocks per stripe.
 .BI resize= max-online-resize
 Reserve enough space so that the block group descriptor table can grow
 to support a filesystem that has max-online-resize blocks.
+.TP
+.BI dir_ireserve
+Reserve inodes for directories during creating the file system.
 .RE
 .TP
 .BI \-f " fragment-size"

-- 
Coly Li
SuSE PRC Labs
