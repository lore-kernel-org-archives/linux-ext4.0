From: Greg KH <gregkh@suse.de>
Subject: [patch 44/60] ext4: return -EIO not -ESTALE on directory traversal through deleted inode
Date: Tue, 09 Jun 2009 17:14:12 -0700
Message-ID: <20090610002349.812972018@blue.kroah.org>
References: <20090610001328.251476848@blue.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	Bryan Donlan <bdonlan@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbZFJDgN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 23:36:13 -0400
Content-Disposition: inline; filename=ext4-return-eio-not-estale-on-directory-traversal-through-deleted-inode.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bryan Donlan <bdonlan@gmail.com>

(cherry picked from commit e6f009b0b45220c004672d41a58865e94946104d)

ext4_iget() returns -ESTALE if invoked on a deleted inode, in order to
report errors to NFS properly.  However, in ext4_lookup(), this
-ESTALE can be propagated to userspace if the filesystem is corrupted
such that a directory entry references a deleted inode.  This leads to
a misleading error message - "Stale NFS file handle" - and confusion
on the part of the admin.

The bug can be easily reproduced by creating a new filesystem, making
a link to an unused inode using debugfs, then mounting and attempting
to ls -l said link.

This patch thus changes ext4_lookup to return -EIO if it receives
-ESTALE from ext4_iget(), as ext4 does for other filesystem metadata
corruption; and also invokes the appropriate ext*_error functions when
this case is detected.

Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/namei.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1055,8 +1055,16 @@ static struct dentry *ext4_lookup(struct
 			return ERR_PTR(-EIO);
 		}
 		inode = ext4_iget(dir->i_sb, ino);
-		if (IS_ERR(inode))
-			return ERR_CAST(inode);
+		if (unlikely(IS_ERR(inode))) {
+			if (PTR_ERR(inode) == -ESTALE) {
+				ext4_error(dir->i_sb, __func__,
+						"deleted inode referenced: %u",
+						ino);
+				return ERR_PTR(-EIO);
+			} else {
+				return ERR_CAST(inode);
+			}
+		}
 	}
 	return d_splice_alias(inode, dentry);
 }


