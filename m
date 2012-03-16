From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/9] ext4: Add -DDEBUG to Makefile
Date: Thu, 15 Mar 2012 17:07:29 -0700
Message-ID: <7ee60f3b750f4500f9bdcb64f358acbf17987036.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add -DDEBUG to enable future use of pr_debug.
No changes to objects as no DEBUG uses currently exist.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 56fd8f86..617a5d8 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the linux ext4-filesystem routines.
 #
 
+ccflags-$(CONFIG_EXT4_FS) := -DDEBUG
+
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
 ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
-- 
1.7.8.111.gad25c.dirty
