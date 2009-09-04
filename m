From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
 in 	failure
Date: Fri, 04 Sep 2009 18:55:37 +0900
Message-ID: <4AA0E419.7010707@rs.jp.nec.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com> <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33612 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933424AbZIDJ4A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 05:56:00 -0400
In-Reply-To: <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,
Peng Tao wrote:
> Hi, Greg,
> 
> On Thu, Sep 3, 2009 at 4:59 AM, Greg Freemyer<greg.freemyer@gmail.com> wrote:
>> Peng,
>>
>> I have not looked at the code very closely, but can you tell me where
>> a file corruption can take place?   Not completing the replacement of
>> extents with donor extents is one thing.  Corrupting the original file
>> contents is another.
> The file corruption is mainly because of the half done replacement.
> 
> My test case is here:
> http://marc.info/?l=linux-ext4&m=124992522305319&w=2
> 

This patch solves your test case problem.

>$dd if=/dev/zero of=zero.img bs=10M count=0 seek=50
>$dd if=../609xp.img of=first.img bs=10M count=1
>$dd if=/dev/zero of=first.img bs=10M count=0 seek=50
>$dd if=../609xp.img of=last.img bs=10M count=1 seek=49
>$dd if=../609xp.img of=middle.img bs=10M count=1 seek=24
>$dd if=/dev/zero of=middle.img bs=10M count=0 seek=50


This problem is caused by the fact that logical offset of
orig file is different from donor file's.
To detect the logical offset difference in EXT4_IOC_MOVE_EXT,
add checks to mext_calc_swap_extents() and handles it as error,
since data exchange must be done between the same blocks.

Note: This problem does not happen in ext4 online defrag
      (means with e4defrag command), because the donor file
      which is created by e4defrag in user space is
      file constitution same as orig file.

And add the extent null check to ext_get_path() for
followings test case.
>$dd if=/dev/zero of=zero.img bs=10M count=0 seek=50

More test cases are needed for EXT4_IOC_MOVE_EXT,
so this patch may not be complete,
but the problem you reported is fixed at least.
I am now testing EXT4_IOC_MOVE_EXT hard.

BTW, I'm now looking into the empty extent issue which
you reported, so I will release the patch soon.
http://marc.info/?l=linux-ext4&m=124975192830024&w=2

Could you do your test case again with this patch?

# Before you apply this patch,
# apply following patch which I sent before:
http://marc.info/?l=linux-ext4&m=125186152727422&w=2

Regards,
Akira Fujita

---
 fs/ext4/move_extent.c |   56 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 0d10f8b..052acd9 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -25,6 +25,8 @@
 		if (IS_ERR(path)) {					\
 			ret = PTR_ERR(path);				\
 			path = NULL;					\
+		} else if (path[ext_depth(inode)].p_ext == NULL) {	\
+			ret = -ENODATA;					\
 		}							\
 	} while (0)

@@ -284,7 +286,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,

 	if (new_flag) {
 		get_ext_path(orig_path, orig_inode, eblock, err);
-		if (orig_path == NULL)
+		if (err)
 			goto out;

 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -295,7 +297,7 @@ mext_insert_across_blocks(handle_t *handle, struct inode *orig_inode,
 	if (end_flag) {
 		get_ext_path(orig_path, orig_inode,
 				      le32_to_cpu(end_ext->ee_block) - 1, err);
-		if (orig_path == NULL)
+		if (err)
 			goto out;

 		if (ext4_ext_insert_extent(handle, orig_inode,
@@ -554,8 +556,10 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
  * @orig_off:		block offset of original inode
  * @donor_off:		block offset of donor inode
  * @max_count:		the maximun length of extents
+ *
+ * Return 0 on success, or a negative error value on failure.
  */
-static void
+static int
 mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 			      struct ext4_extent *tmp_oext,
 			      ext4_lblk_t orig_off, ext4_lblk_t donor_off,
@@ -564,6 +568,19 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,
 	ext4_lblk_t diff, orig_diff;
 	struct ext4_extent dext_old, oext_old;

+	BUG_ON(orig_off != donor_off);
+
+	/* original and donor extents have to cover the same block offset */
+	if (orig_off < le32_to_cpu(tmp_oext->ee_block) ||
+	    le32_to_cpu(tmp_oext->ee_block) +
+			ext4_ext_get_actual_len(tmp_oext) - 1 < orig_off)
+		return -ENODATA;
+
+	if (orig_off < le32_to_cpu(tmp_dext->ee_block) ||
+	    le32_to_cpu(tmp_dext->ee_block) +
+			ext4_ext_get_actual_len(tmp_dext) - 1 < orig_off)
+		return -ENODATA;
+
 	dext_old = *tmp_dext;
 	oext_old = *tmp_oext;

@@ -591,6 +608,8 @@ mext_calc_swap_extents(struct ext4_extent *tmp_dext,

 	copy_extent_status(&oext_old, tmp_dext);
 	copy_extent_status(&dext_old, tmp_oext);
+
+	return 0;
 }

 /**
@@ -632,12 +651,12 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,

 	/* Get the original extent for the block "orig_off" */
 	get_ext_path(orig_path, orig_inode, orig_off, err);
-	if (orig_path == NULL)
+	if (err)
 		goto out;

 	/* Get the donor extent for the head */
 	get_ext_path(donor_path, donor_inode, donor_off, err);
-	if (donor_path == NULL)
+	if (err)
 		goto out;
 	depth = ext_depth(orig_inode);
 	oext = orig_path[depth].p_ext;
@@ -647,8 +666,10 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	dext = donor_path[depth].p_ext;
 	tmp_dext = *dext;

-	mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
+	err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
 				      donor_off, count);
+	if (err)
+		goto out;

 	/* Loop for the donor extents */
 	while (1) {
@@ -679,7 +700,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		get_ext_path(orig_path, orig_inode, orig_off, err);
-		if (orig_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(orig_inode);
 		oext = orig_path[depth].p_ext;
@@ -694,7 +715,7 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 			ext4_ext_drop_refs(donor_path);
 		get_ext_path(donor_path, donor_inode,
 				      donor_off, err);
-		if (donor_path == NULL)
+		if (err)
 			goto out;
 		depth = ext_depth(donor_inode);
 		dext = donor_path[depth].p_ext;
@@ -705,9 +726,10 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 		}
 		tmp_dext = *dext;

-		mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
-					      donor_off,
-					      count - replaced_count);
+		err = mext_calc_swap_extents(&tmp_dext, &tmp_oext, orig_off,
+					   donor_off, count - replaced_count);
+		if (err)
+			goto out;
 	}

 out:
@@ -1147,20 +1169,16 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		len -= block_end - file_end;

 	get_ext_path(orig_path, orig_inode, block_start, ret);
-	if (orig_path == NULL)
+	if (ret)
 		goto out2;

 	/* Get path structure to check the hole */
 	get_ext_path(holecheck_path, orig_inode, block_start, ret);
-	if (holecheck_path == NULL)
+	if (ret)
 		goto out;

 	depth = ext_depth(orig_inode);
 	ext_cur = holecheck_path[depth].p_ext;
-	if (ext_cur == NULL) {
-		ret = -EINVAL;
-		goto out;
-	}

 	/*
 	 * Get proper extent whose ee_block is beyond block_start
@@ -1283,7 +1301,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 			ext4_ext_drop_refs(holecheck_path);
 		get_ext_path(holecheck_path, orig_inode,
 				      seq_start, ret);
-		if (holecheck_path == NULL)
+		if (ret)
 			break;
 		depth = holecheck_path->p_depth;

@@ -1291,7 +1309,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 		if (orig_path)
 			ext4_ext_drop_refs(orig_path);
 		get_ext_path(orig_path, orig_inode, seq_start, ret);
-		if (orig_path == NULL)
+		if (ret)
 			break;

 		ext_cur = holecheck_path[depth].p_ext;
