From: Darren Hart <dvhart@infradead.org>
Subject: [PATCH 3/3] libext2fs: Remove obsolete redefinition of EXT2_FT_DIR
Date: Fri,  4 Jan 2013 12:01:00 -0800
Message-ID: <482b22be6370e473ba5a4af9a7bf9f267321ae49.1357329054.git.dvhart@infradead.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Cc: tytso@mit.edu, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com, Darren Hart <dvhart@infradead.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38429
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005Ab3ADUB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jan 2013 15:01:28 -0500
In-Reply-To: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
In-Reply-To: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
References: <3fd850c4bf72f868b0d93bb0a5acced51fd25caa.1357329054.git.dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was needed a decade or more ago, back when we included
ext2_fs.h from the kernel headers in /usr/include/linux.

Signed-off-by: Darren Hart <dvhart@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>
---
 lib/ext2fs/mkdir.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 4a85439..9d69f70 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -27,10 +27,6 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-#ifndef EXT2_FT_DIR
-#define EXT2_FT_DIR		2
-#endif
