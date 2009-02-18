From: Greg KH <gregkh@suse.de>
Subject: [patch 34/36] ext4: Add sanity check to make_indexed_dir
Date: Wed, 18 Feb 2009 14:29:58 -0800
Message-ID: <20090218222958.GI10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757962AbZBRWcZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:25 -0500
Content-Disposition: inline; filename="ext4-add-sanity-check-to-make_indexed_dir.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit e6b8bc09ba2075cd91fbffefcd2778b1a00bd76f)

Make sure the rec_len field in the '..' entry is sane, lest we overrun
the directory block and cause a kernel oops on a purposefully
corrupted filesystem.

Thanks to Sami Liedes for reporting this bug.

http://bugzilla.kernel.org/show_bug.cgi?id=12430

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/namei.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1382,7 +1382,7 @@ static int make_indexed_dir(handle_t *ha
 	struct fake_dirent *fde;
 
 	blocksize =  dir->i_sb->s_blocksize;
-	dxtrace(printk("Creating index\n"));
+	dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
 	retval = ext4_journal_get_write_access(handle, bh);
 	if (retval) {
 		ext4_std_error(dir->i_sb, retval);
@@ -1391,6 +1391,20 @@ static int make_indexed_dir(handle_t *ha
 	}
 	root = (struct dx_root *) bh->b_data;
 
+	/* The 0th block becomes the root, move the dirents out */
+	fde = &root->dotdot;
+	de = (struct ext4_dir_entry_2 *)((char *)fde +
+		ext4_rec_len_from_disk(fde->rec_len));
+	if ((char *) de >= (((char *) root) + blocksize)) {
+		ext4_error(dir->i_sb, __func__,
+			   "invalid rec_len for '..' in inode %lu",
+			   dir->i_ino);
+		brelse(bh);
+		return -EIO;
+	}
+	len = ((char *) root) + blocksize - (char *) de;
+
+	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append (handle, dir, &block, &retval);
 	if (!(bh2)) {
 		brelse(bh);
@@ -1399,11 +1413,6 @@ static int make_indexed_dir(handle_t *ha
 	EXT4_I(dir)->i_flags |= EXT4_INDEX_FL;
 	data1 = bh2->b_data;
 
-	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len));
-	len = ((char *) root) + blocksize - (char *) de;
 	memcpy (data1, de, len);
 	de = (struct ext4_dir_entry_2 *) data1;
 	top = data1 + len;

