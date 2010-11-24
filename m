From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Add FITRIM handle for ext3
Date: Wed, 24 Nov 2010 14:01:47 +0100
Message-ID: <20101124130147.GP6113@quack.suse.cz>
References: <1290425358-16253-1-git-send-email-lczerner@redhat.com>
 <1290425358-16253-2-git-send-email-lczerner@redhat.com>
 <20101122174220.GC5012@quack.suse.cz>
 <alpine.LFD.2.00.1011231126380.3139@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0KXNBt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Nov 2010 08:01:49 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011231126380.3139@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 23-11-10 11:32:46, Lukas Czerner wrote:
> On Mon, 22 Nov 2010, Jan Kara wrote:
> 
> > On Mon 22-11-10 12:29:18, Lukas Czerner wrote:
> > > It takes fstrim_range structure as an argument. fstrim_range is definec in
> > > the include/linux/fs.h.
> > > 
> > > After the FITRIM is done, the number of actually discarded Bytes is stored
> > > in fstrim_range.len to give the user better insight on how much storage
> > > space has been really released for wear-leveling.
> >   Umm, why do we have to do this when FITRIM is already handled in
> > fs/ioctl.c? I'd expect us to just provide .trim_fs ioctl, no?
> 
> Hi,
> 
> see upstream commits:
> 93bb41f4f8b89ac8b4d0a734bc59634cb0a29a89
> e681c047e47c0abe67bf95857f23814372793cb0
> 
> unfortunately people was not happy with generic ioctl interface for that
> purpose, there were concerned that it is no common enough to be included
> in core vfs and there is no need for new super operation since each
> filesystem can easily setup its own ioctl handling.
> 
> When I say people I need to clarify that it was mainly Christoph Hellwig
> who had objections against the former implementation and I must say that
> he had a point.
OK, I see. I had a fresh look at the patches and I've found a few
suboptimal things which I've fixed. Most notably I don't think we have to
issue a warning when underlying device does not support FITRIM. Returning
EOPNOTSUPP should be enough. And I also think that remounting the
filesystem read-only or even panicking (the result of calling
ext3_std_error()) is necessary when sb_issue_discard() fails for whatever
reason. Sure it is suspicious but we can cope just fine with that. BTW, I
think ext4 might want this as well. Finally, we were missing to set the
error in a few cases (e.g. when bitmap could not be loaded).

Attached is a diff with what I did and I'll repost what I currently have in
my tree.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext3-discard-update

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 8393abf..878cbca 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1935,14 +1935,14 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 	 * We will update one block bitmap, and one group descriptor
 	 */
 	handle = ext3_journal_start_sb(sb, 2);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		return err;
-	}
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 
 	bitmap_bh = read_block_bitmap(sb, group);
-	if (!bitmap_bh)
+	if (!bitmap_bh) {
+		err = -EIO;
 		goto err_out;
+	}
 
 	BUFFER_TRACE(bitmap_bh, "getting undo access");
 	err = ext3_journal_get_undo_access(handle, bitmap_bh);
@@ -1950,8 +1950,10 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 		goto err_out;
 
 	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
-	if (!gdp)
+	if (!gdp) {
+		err = -EIO;
 		goto err_out;
+	}
 
 	BUFFER_TRACE(gdp_bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, gdp_bh);
@@ -1963,7 +1965,6 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 
 	 /* Walk through the whole group */
 	while (start < max) {
-
 		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
 		if (start < 0)
 			break;
@@ -1997,7 +1998,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 			goto free_extent;
 
 		 /* Send the TRIM command down to the device */
-		ret = sb_issue_discard(sb, discard_block, next - start,
+		err = sb_issue_discard(sb, discard_block, next - start,
 				       GFP_NOFS, 0);
 		count += (next - start);
 free_extent:
@@ -2023,22 +2024,18 @@ free_extent:
 		spin_lock(sb_bgl_lock(sbi, group));
 		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
 		spin_unlock(sb_bgl_lock(sbi, group));
-		percpu_counter_add(&sbi->s_freeblocks_counter, next - start);
+		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
 
 		start = next;
-		if (ret < 0) {
-			if (ret == -EOPNOTSUPP) {
-				ext3_warning(sb, __func__,
-					"discard not supported!");
-				count = ret;
-				break;
-			}
-			err = ret;
+		if (err < 0) {
+			if (err != -EOPNOTSUPP)
+				ext3_warning(sb, __func__, "Discard command "
+					     "returned error %d\n", err);
 			break;
 		}
 
 		if (fatal_signal_pending(current)) {
-			count = -ERESTARTSYS;
+			err = -ERESTARTSYS;
 			break;
 		}
 
@@ -2063,12 +2060,10 @@ free_extent:
 		count, group);
 
 err_out:
-	if (err) {
-		ext3_std_error(sb, err);
+	if (err)
 		count = err;
-	}
 	ext3_journal_stop(handle);
 	brelse(bitmap_bh);
 

--liOOAslEiF7prFVr--
