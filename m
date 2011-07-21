From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH XFSPROGS 3/3] mkfs: Link against libuuid after liblkid
Date: Thu, 21 Jul 2011 19:50:37 -0400
Message-ID: <1311292237-4155-3-git-send-email-tytso@mit.edu>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49496 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab1GUXut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 19:50:49 -0400
In-Reply-To: <1311292237-4155-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The order in which libraries are searched matters if you are using
static libraries.  Since libblkid uses some functions from libuuid, it
needs to come before libuuid in the link line.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 mkfs/Makefile |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 8b61c2f..75da633 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,10 +11,6 @@ FSTYP = fstyp
 HFILES = xfs_mkfs.h
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS)
-LLDFLAGS = -static
