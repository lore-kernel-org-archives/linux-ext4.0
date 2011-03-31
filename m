From: Jan Kara <jack@suse.cz>
Subject: Re: kernel BUG at fs/jbd2/transaction.c:1086!
Date: Thu, 31 Mar 2011 18:43:19 +0200
Message-ID: <20110331164319.GG21524@quack.suse.cz>
References: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu,
	Eric Sandeen <esandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755Ab1CaQnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2011 12:43:21 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103301651240.17917@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 30-03-11 17:32:06, Lukas Czerner wrote:
> Hello,
> 
> I have hit BUG_ON while running xfstest 234 in the loop
> on the ext4. Backtrace below .
> 
> I thought that this problem was solved with
> 67eeb5685d2a211c0252ac7884142e503c759500 however it is still present.
> I might be a bit hard to hit, but once you run
> 
> while true; do sync; sleep 0.3; done
> 
> concurrently it is reproducible almost all the time. I have tried to
> understand what is going on but only thing I can see is this course
> of action:
> 
> ext4_write_dquot
>   ext4_journal_start <- h_buffer_credits = 2
>   dquot_commit
>     v2_write_dquot
>       qtree_write_dquot
>         ext4_quota_write
>           ext4_handle_dirty_metadata	<- this takes one block reserved
> 	  				   for journal
> 					   h_buffer_credits--
>     v2_write_file_info
>       ext4_quota_write
>         ext4_handle_dirty_metadata	<- this takes second block reserved
> 	  				   for journal
> 					   h_buffer_credits--
>   ext4_journal_stop
> 
> However apparently I am missing something, because according to the
> backtrace the second call of jbd2_journal_dirty_metadata() may end up
> with BUG_ON -> J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
> 
> So someone else is touching our handle apparently, but I go not exacly
> know what is going on. From my simple debugging printk information I
> have put with before ext4_handle_dirty_metadata() in ext4_quota_write()
> we can see:
> 
> [  226.450263] ext4_quota_write: len 48, off 5136, type 0 h_ref 1
> credits 2
> [  226.458950] ext4_quota_write: len 24, off 8, type 0 h_ref 1 credits 0
> 
> It is clear someone changed handle between v2_write_dquot() and
> v2_write_file_info() does anyone have idea what is going on ?
  It's simpler than that I believe. ext4_write_dquot() does also
        inode->i_mtime = inode->i_ctime = CURRENT_TIME;
        ext4_mark_inode_dirty(handle, inode);
and that eats another credit. Looking at the comment before
EXT4_QUOTA_TRANS_BLOCKS, we in fact counted with inode and data update but
didn't count with the info update. It's actually a race that we ended up
doing info update in our transaction - someone marked info dirty and before
he managed to write it, we went in, saw the dirty flag and wrote it for
him. So the attached patch should fix the problem for you.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--0OAP2g/MAC+5xKAE
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-quota-Don-t-write-quota-info-in-dquot_commit.patch"

>From 029defbf639cb228a513a6c056cd601841ebf4ab Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 31 Mar 2011 18:36:52 +0200
Subject: [PATCH] quota: Don't write quota info in dquot_commit()

There's no reason to write quota info in dquot_commit(). The writing is a
relict from the old days when we didn't have dquot_acquire() and
dquot_release() and thus dquot_commit() could have created / removed quota
structures from the file. These days dquot_commit() only updates usage counters
/ limits in quota structure and thus there's no need to write quota info.

This also fixes an issue with journaling filesystem which didn't reserve
enough space in the transaction for write of quota info (it could have been
dirty at the time of dquot_commit() because of a race with other operation
changing it).

Reported-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a2a622e..b59ee61 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -442,7 +442,7 @@ EXPORT_SYMBOL(dquot_acquire);
  */
 int dquot_commit(struct dquot *dquot)
 {
-	int ret = 0, ret2 = 0;
+	int ret = 0;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dqopt->dqio_mutex);
@@ -454,15 +454,10 @@ int dquot_commit(struct dquot *dquot)
 	spin_unlock(&dq_list_lock);
 	/* Inactive dquot can be only if there was error during read/init
 	 * => we have better not writing it */
-	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
 		ret = dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
-		if (info_dirty(&dqopt->info[dquot->dq_type])) {
-			ret2 = dqopt->ops[dquot->dq_type]->write_file_info(
-						dquot->dq_sb, dquot->dq_type);
-		}
-		if (ret >= 0)
-			ret = ret2;
-	}
+	else
+		ret = -EIO;
 out_sem:
 	mutex_unlock(&dqopt->dqio_mutex);
 	return ret;
-- 
1.7.1


--0OAP2g/MAC+5xKAE--
