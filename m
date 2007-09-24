From: "Theodore Ts'o" <tytso@mit.edu>
Subject: mballoc-core
Date: Mon, 24 Sep 2007 10:11:05 -0400
Message-ID: <E1IZoeP-0002H7-Sf@tinytim.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58172 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbXIXOLK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Sep 2007 10:11:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

FYI, I updated the mballoc-core patch in the ext4-patch-queue to not try
to pull in both ext4_jbd2.h and jbd.h; this was causing duplicate
definition, so I removed the #include of jbd.h

	       	 	     	      	 - Ted

    Remove #include of linux/jbd.h from mballoc-core so it will compile

diff --git a/mballoc-core.patch b/mballoc-core.patch
index b8839b4..1079692 100644
--- a/mballoc-core.patch
+++ b/mballoc-core.patch
@@ -357,7 +357,7 @@ Index: linux-2.6.23-rc6/fs/ext4/mballoc.c
 ===================================================================
 --- /dev/null	1970-01-01 00:00:00.000000000 +0000
 +++ linux-2.6.23-rc6/fs/ext4/mballoc.c	2007-09-20 17:26:22.000000000 -0700
-@@ -0,0 +1,4460 @@
+@@ -0,0 +1,4459 @@
 +/*
 + * Copyright (c) 2003-2006, Cluster File Systems, Inc, info@clusterfs.com
 + * Written by Alex Tomas <alex@clusterfs.com>
@@ -385,7 +385,6 @@ Index: linux-2.6.23-rc6/fs/ext4/mballoc.c
 +#include <linux/fs.h>
 +#include <linux/namei.h>
 +#include <linux/ext4_jbd2.h>
-+#include <linux/jbd.h>
 +#include <linux/ext4_fs.h>
 +#include <linux/quotaops.h>
 +#include <linux/buffer_head.h>
