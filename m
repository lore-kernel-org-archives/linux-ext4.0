From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 2/2] ext4: fix null pointer bug in move_extent.c
Date: Mon, 03 Aug 2009 17:30:59 +0900
Message-ID: <4A76A043.20105@rs.jp.nec.com>
References: <1249213404-6277-1-git-send-email-bergwolf@gmail.com> <1249213404-6277-2-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:54214 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZHCIbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 04:31:21 -0400
In-Reply-To: <1249213404-6277-2-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Peng Tao wrote:
> In mext_replace_branches(), the oext and dext virable might be NULL if the
> orig extent and donor extent are empty. Later calling *oext and *dext will
> trigger a kernel null pointer bug like this:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffffa0636563>] mext_replace_branches+0x10c/0x2f3 [ext4]
> PGD 37dba067 PUD cd8ac067 PMD 0
> Oops: 0000 [#1] SMP
> 
> The patch checks the two virables and returns EOPNOTSUPP if either of them
> is NULL.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
>  fs/ext4/move_extent.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 5821e0b..4923f70 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -641,10 +641,22 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
>  		goto out;
>  	depth = ext_depth(orig_inode);
>  	oext = orig_path[depth].p_ext;
> +	if (oext == NULL) {
> +		ext4_debug("ext4 move extent: "
> +					"orig extents should not be empty\n");
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
>  	tmp_oext = *oext;
>  
>  	depth = ext_depth(donor_inode);
>  	dext = donor_path[depth].p_ext;
> +	if (dext == NULL) {
> +		ext4_debug("ext4 move extent: "
> +					"donor extents should not be empty\n");
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
>  	tmp_dext = *dext;
>  
>  	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,

Yes, this problem occurs if extent which ext4_ext_path indicates is NULL,
but this check should be done in ext4_move_extents()
which is called before mext_replace_branches().
And in this case, ENOENT is better for error value, I think.
How about this patch?

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>

---
 move_extent.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)
--- ../../LATEST/fs/ext4/move_extent.c	2009-08-03 14:53:43.000000000 +0900
+++ fs/ext4/move_extent.c	2009-08-03 15:03:33.000000000 +0900
@@ -1145,19 +1145,23 @@ ext4_move_extents(struct file *o_filp, s
 	if (file_end < block_end)
 		len -= block_end - file_end;

+	depth = ext_depth(orig_inode);
 	get_ext_path(orig_path, orig_inode, block_start, ret);
 	if (orig_path == NULL)
 		goto out2;
+	else if (orig_path[depth].p_ext == NULL) {
+		ret = -ENOENT;
+		goto out;
+	}

 	/* Get path structure to check the hole */
 	get_ext_path(holecheck_path, orig_inode, block_start, ret);
 	if (holecheck_path == NULL)
 		goto out;

-	depth = ext_depth(orig_inode);
 	ext_cur = holecheck_path[depth].p_ext;
 	if (ext_cur == NULL) {
-		ret = -EINVAL;
+		ret = -ENOENT;
 		goto out;
 	}

@@ -1280,11 +1284,14 @@ ext4_move_extents(struct file *o_filp, s
 		/* Decrease buffer counter */
 		if (holecheck_path)
 			ext4_ext_drop_refs(holecheck_path);
-		get_ext_path(holecheck_path, orig_inode,
-				      seq_start, ret);
+		get_ext_path(holecheck_path, orig_inode, seq_start, ret);
 		if (holecheck_path == NULL)
 			break;
 		depth = holecheck_path->p_depth;
+		if (holecheck_path[depth].p_ext == NULL) {
+			ret = -ENOENT;
+			break;
+		}

 		/* Decrease buffer counter */
 		if (orig_path)
@@ -1292,6 +1299,10 @@ ext4_move_extents(struct file *o_filp, s
 		get_ext_path(orig_path, orig_inode, seq_start, ret);
 		if (orig_path == NULL)
 			break;
+		else if (orig_path[depth].p_ext == NULL) {
+			ret = -ENOENT;
+			break;
+		}

 		ext_cur = holecheck_path[depth].p_ext;
 		add_blocks = ext4_ext_get_actual_len(ext_cur);
