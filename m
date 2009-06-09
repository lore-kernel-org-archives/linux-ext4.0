From: Greg KH <gregkh@suse.de>
Subject: [patch 75/87] ext4: Automatically allocate delay allocated blocks on close
Date: Tue, 09 Jun 2009 02:40:03 -0700
Message-ID: <20090609094109.986748238@blue.kroah.org>
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
Received: from kroah.org ([198.145.64.141]:55522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760869AbZFIKVt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2009 06:21:49 -0400
Content-Disposition: inline; filename=ext4-automatically-allocate-delay-allocated-blocks-on-close.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit 7d8f9f7d150dded7b68e61ca6403a1f166fb4edf)

When closing a file that had been previously truncated, force any
delay allocated blocks that to be allocated so that if the filesystem
is mounted with data=ordered, the data blocks will be pushed out to
disk along with the journal commit.  Many application programs expect
this, so we do this to avoid zero length files if the system crashes
unexpectedly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/file.c  |    4 ++++
 fs/ext4/inode.c |    3 +++
 3 files changed, 8 insertions(+)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -279,6 +279,7 @@ static inline __u32 ext4_mask_flags(umod
 #define EXT4_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
 #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
+#define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -33,6 +33,10 @@
  */
 static int ext4_release_file(struct inode *inode, struct file *filp)
 {
+	if (EXT4_I(inode)->i_state & EXT4_STATE_DA_ALLOC_CLOSE) {
+		ext4_alloc_da_blocks(inode);
+		EXT4_I(inode)->i_state &= ~EXT4_STATE_DA_ALLOC_CLOSE;
+	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1))
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3880,6 +3880,9 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
+	if (inode->i_size == 0)
+		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
+
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		ext4_ext_truncate(inode);
 		return;


