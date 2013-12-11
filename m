From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/74] debugfs: don't leak fd when calling dump_file
Date: Tue, 10 Dec 2013 17:20:07 -0800
Message-ID: <20131211012007.30655.55062.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42476 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3LKBUN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:13 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The caller of dump_file provides a fd to write to, so the caller
should also dispose of the fd.  Also, the fd never gets closed if
preserve=1.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/dump.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/debugfs/dump.c b/debugfs/dump.c
index c75b9f1..952a752 100644
--- a/debugfs/dump.c
+++ b/debugfs/dump.c
@@ -143,8 +143,6 @@ static void dump_file(const char *cmdname, ext2_ino_t ino, int fd,
 
 	if (preserve)
 		fix_perms("dump_file", &inode, fd, outname);
-	else if (fd != 1)
-		close(fd);
 
 	return;
 }
@@ -191,6 +189,11 @@ void do_dump(int argc, char **argv)
 	}
 
 	dump_file(argv[0], inode, fd, preserve, out_fn);
+	if (close(fd) != 0) {
+		com_err(argv[0], errno, "while closing %s for dump_inode",
+			out_fn);
+		return;
+	}
 
 	return;
 }
@@ -273,6 +276,10 @@ static void rdump_inode(ext2_ino_t ino, struct ext2_inode *inode,
 			goto errout;
 		}
 		dump_file("rdump", ino, fd, 1, fullname);
+		if (close(fd) != 0) {
+			com_err("rdump", errno, "while dumping %s", fullname);
+			goto errout;
+		}
 	}
 	else if (LINUX_S_ISDIR(inode->i_mode) && strcmp(name, ".") && strcmp(name, "..")) {
 		errcode_t retval;

