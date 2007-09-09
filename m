From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RESEND][PATCH] dir_index: error out instead of BUG on corrupt
	hash dir limit
Date: Sun, 9 Sep 2007 14:19:33 +0100
Message-ID: <20070909131933.GA15229@dastardly.plus.com>
References: <46D8D30B.6090703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3868 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbXIIN0R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Sep 2007 09:26:17 -0400
Content-Disposition: inline
In-Reply-To: <46D8D30B.6090703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Eric,

On Fri, Aug 31, 2007 at 09:48:43PM -0500, Eric Sandeen wrote:
> (resend, this one got lost?  Got an acked-by from Andreas
> last go-round)

Sorry I missed this first time around. I came up with a very similar
fix recently, following a gentoo bug report.  However there are a few
more asserts later that you aren't currently handling. Below is an
incremental patch on top of yours that converts them too. Note that one
of them is in an if (0) block and maybe should be left alone -- what do
you think?

I tested all the changed code paths, except the if (0) one, using a
utility that appropriately corrupts ext3 images. The source code is
attached to the gentoo bug report here:

http://bugs.gentoo.org/show_bug.cgi?id=183207

Signed-off-by: Duane Griffin <duaneg@dghda.com>

Index: linux-2.6-git/fs/ext3/namei.c
===================================================================
--- linux-2.6-git.orig/fs/ext3/namei.c
+++ linux-2.6-git/fs/ext3/namei.c
@@ -393,7 +393,15 @@ dx_probe(struct dentry *dentry, struct i
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "Corrupt limit in dir inode %ld\n",
+				     dir->i_ino);
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -419,7 +427,11 @@ dx_probe(struct dentry *dentry, struct i
 					break;
 				}
 			}
-			assert (at == p - 1);
+			if (at != p - 1) {
+				brelse(bh);
+				*err = ERR_BAD_DX_DIR;
+				goto fail2;
+			}
 		}
 
 		at = p - 1;
@@ -431,8 +443,16 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext3_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "Corrupt limit in dir inode %ld\n",
+				     dir->i_ino);
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {
Index: linux-2.6-git/fs/ext4/namei.c
===================================================================
--- linux-2.6-git.orig/fs/ext4/namei.c
+++ linux-2.6-git/fs/ext4/namei.c
@@ -393,7 +393,15 @@ dx_probe(struct dentry *dentry, struct i
 	while (1)
 	{
 		count = dx_get_count(entries);
-		assert (count && count <= dx_get_limit(entries));
+		if (!count || count > dx_get_limit(entries)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "Corrupt limit in dir inode %ld\n",
+				     dir->i_ino);
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
+
 		p = entries + 1;
 		q = entries + count - 1;
 		while (p <= q)
@@ -419,7 +427,11 @@ dx_probe(struct dentry *dentry, struct i
 					break;
 				}
 			}
-			assert (at == p - 1);
+			if (at != p - 1) {
+				brelse(bh);
+				*err = ERR_BAD_DX_DIR;
+				goto fail2;
+			}
 		}
 
 		at = p - 1;
@@ -431,8 +443,16 @@ dx_probe(struct dentry *dentry, struct i
 		if (!(bh = ext4_bread (NULL,dir, dx_get_block(at), 0, err)))
 			goto fail2;
 		at = entries = ((struct dx_node *) bh->b_data)->entries;
-		assert (dx_get_limit(entries) == dx_node_limit (dir));
+		if (dx_get_limit(entries) != dx_node_limit (dir)) {
+			ext3_warning(dir->i_sb, __FUNCTION__,
+				     "Corrupt limit in dir inode %ld\n",
+				     dir->i_ino);
+			brelse(bh);
+			*err = ERR_BAD_DX_DIR;
+			goto fail2;
+		}
 		frame++;
+		frame->bh = NULL;
 	}
 fail2:
 	while (frame >= frame_in) {

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
