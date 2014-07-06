From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Sun, 6 Jul 2014 15:43:25 +0200
Message-ID: <20140706134325.GA18955@amd.pavel.ucw.cz>
References: <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <20140704185626.GB11103@thunk.org>
 <20140706133247.GB18204@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>,
	kernel list <linux-kernel@vger.kernel.org>,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140706133247.GB18204@amd.pavel.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi!

> Now I'm running fsck.new -cf. I don't think this filesystem has any
> bad blocks. Still, it says "rootfs: Updating bad block inode."
> ... "FILE SYSTEM WAS MODIFIED", "REBOOT LINUX".

And here's patch to fix this uglyness. Unfortunately, it makes it read
the inode... but perhaps it is good idea as we are able to print
before/after bad block counts...?

Signed-off-by: Pavel Machek <pavel@ucw.cz>

Thanks,
								Pavel

diff --git a/e2fsck/badblocks.c b/e2fsck/badblocks.c
index 7f3641b..32e08bf 100644
--- a/e2fsck/badblocks.c
+++ b/e2fsck/badblocks.c
@@ -30,6 +30,7 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 	ext2_filsys fs = ctx->fs;
 	errcode_t	retval;
 	badblocks_list	bb_list = 0;
+	int		old_bb_count = -1;
 	FILE		*f;
 	char		buf[1024];
 
@@ -51,14 +52,16 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 	 * If we're appending to the bad blocks inode, read in the
 	 * current bad blocks.
 	 */
-	if (!replace_bad_blocks) {
-		retval = ext2fs_read_bb_inode(fs, &bb_list);
-		if (retval) {
-			com_err("ext2fs_read_bb_inode", retval, "%s",
-				_("while reading the bad blocks inode"));
-			goto fatal;
-		}
+	retval = ext2fs_read_bb_inode(fs, &bb_list);
+	if (retval) {
+		com_err("ext2fs_read_bb_inode", retval, "%s",
+			_("while reading the bad blocks inode"));
+		goto fatal;
 	}
+	old_bb_count = ext2fs_u32_list_count(bb_list);
+	printf("%s: Currently %d bad blocks.\n", ctx->device_name, old_bb_count);
+	if (replace_bad_blocks)
+		bb_list = 0;
 
 	/*
 	 * Now read in the bad blocks from the file; if
@@ -95,10 +98,16 @@ void read_bad_blocks_file(e2fsck_t ctx, const char *bad_blocks_file,
 		goto fatal;
 	}
 
+	if ((ext2fs_u32_list_count(bb_list) == 0) &&
+	    ((!replace_bad_blocks) || (!old_bb_count))) {
+	  	printf("%s: No bad blocks found, no update neeeded.\n", ctx->device_name);
+		return;
+	}
+
 	/*
 	 * Finally, update the bad blocks from the bad_block_map
 	 */
-	printf("%s: Updating bad block inode.\n", ctx->device_name);
+	printf("%s: Updating bad block inode (%d bad blocks).\n", ctx->device_name, ext2fs_u32_list_count(bb_list));
 	retval = ext2fs_update_bb_inode(fs, bb_list);
 	if (retval) {
 		com_err("ext2fs_update_bb_inode", retval, "%s",

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
