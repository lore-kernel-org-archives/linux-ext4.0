From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1 10/10] Add "hash_alg=siphash" support
Date: 23 Sep 2014 06:31:06 -0400
Message-ID: <20140923103106.18356.qmail@ns.horizon.com>
References: <20140923100214.26896.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:59108 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755259AbaIWKbI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:31:08 -0400
In-Reply-To: <20140923100214.26896.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The #define name refers specifically to SipHash-2-4, but keep the
parameter name short.

Signed-off-by: George Spelvin <linux@horizon.com>
---
The other half of the implementation.

 lib/e2p/hashstr.c     | 1 +
 misc/mke2fs.conf.5.in | 3 ++-
 misc/tune2fs.8.in     | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/e2p/hashstr.c b/lib/e2p/hashstr.c
index a73758c..bd4a8da 100644
--- a/lib/e2p/hashstr.c
+++ b/lib/e2p/hashstr.c
@@ -27,6 +27,7 @@ static struct hash hash_list[] = {
 	{	EXT2_HASH_LEGACY, 	"legacy" },
 	{	EXT2_HASH_HALF_MD4, 	"half_md4" },
 	{	EXT2_HASH_TEA, 		"tea" },
+	{	EXT2_HASH_SIPHASH24,	"siphash" },
 	{	0, 0 },
 };
 
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index ad6c11b..257bddd 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -173,8 +173,9 @@ new filesystems with hashed b-tree directories.  Valid algorithms
 accepted are:
 .IR legacy ,
 .IR half_md4 ,
+.IR tea ,
 and
-.IR tea .
+.IR siphash .
 .TP
 .I inode_ratio
 This relation specifies the default inode ratio if the user does not
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index c50d475..f25f177 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -209,8 +209,9 @@ Set the default hash algorithm used for filesystems with hashed b-tree
 directories.  Valid algorithms accepted are:
 .IR legacy ,
 .IR half_md4 ,
+.IR tea ,
 and
-.IR tea .
+.IR siphash .
 .TP
 .BI mount_opts= mount_option_string
 Set a set of default mount options which will be used when the file
-- 
2.1.0

