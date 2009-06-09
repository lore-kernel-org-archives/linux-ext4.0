From: Greg KH <gregkh@suse.de>
Subject: [patch 82/87] ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
Date: Tue, 09 Jun 2009 02:40:10 -0700
Message-ID: <20090609094111.622823567@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
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
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:32863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760882AbZFIKWQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:22:16 -0400
Content-Disposition: inline; filename=ext4-fix-softlockup-caused-by-illegal-i_file_acl-value-in-on-disk-inode.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 485c26ec70f823f2a9cf45982b724893e53a859e)

If the block containing external extended attributes (which is stored
in i_file_acl and i_file_acl_high) is larger than the on-disk
filesystem, the process which tried to access the extended attributes
will endlessly issue kernel printks complaining that
"__find_get_block_slow() failed", locking up that CPU until the system
is forcibly rebooted.

So when we read in the inode, make sure the i_file_acl value is legal,
and if not, flag the filesystem as being corrupted.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4351,6 +4351,18 @@ struct inode *ext4_iget(struct super_blo
 			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
 	}
 
+	if (ei->i_file_acl &&
+	    ((ei->i_file_acl <
+	      (le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
+	       EXT4_SB(sb)->s_gdb_count)) ||
+	     (ei->i_file_acl >= ext4_blocks_count(EXT4_SB(sb)->s_es)))) {
+		ext4_error(sb, __func__,
+			   "bad extended attribute block %llu in inode #%lu",
+			   ei->i_file_acl, inode->i_ino);
+		ret = -EIO;
+		goto bad_inode;
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;


