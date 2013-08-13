From: Jan Kara <jack@suse.cz>
Subject: Re: crash in __jbd2_journal_file_buffer
Date: Tue, 13 Aug 2013 12:34:16 +0200
Message-ID: <20130813103416.GA12197@quack.suse.cz>
References: <alpine.DEB.2.00.1307301540110.12830@cobra.newdream.net>
 <20130731190245.GC28018@quack.suse.cz>
 <alpine.DEB.2.00.1308091031450.17790@cobra.newdream.net>
 <20130809212425.GB1050@quack.suse.cz>
 <alpine.DEB.2.00.1308091504320.14125@cobra.newdream.net>
 <20130812125256.GB4596@quack.suse.cz>
 <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Sage Weil <sage@inktank.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab3HMKeT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Aug 2013 06:34:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1308121106320.29150@cobra.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 12-08-13 11:13:06, Sage Weil wrote:
> Full dmesg is attached.
  Hum, nothing interesting in there...

> Our QA seems to hit this with some regularity.  Let me know if there's 
> some combination of patches that would help shed more light!
  If they can run with attached debug patch it could maybe sched some more
light. Please send also your System.map file together with the dmesg of the
kernel when the crash happens so that I can map addresses to function
names... Thanks!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--FL5UXtIhxfXey3p5
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Debug-journal_head-additions-and-removals.patch"

>From ae473a63b28ee1719cf47a637c73d9d163ddb4db Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 13 Aug 2013 12:29:35 +0200
Subject: [PATCH] jbd2: Debug journal_head additions and removals

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c           | 4 ++++
 fs/jbd2/transaction.c       | 4 ++++
 include/linux/buffer_head.h | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 02c7ad9..227a1ab 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2433,6 +2433,8 @@ repeat:
 		bh->b_private = jh;
 		jh->b_bh = bh;
 		get_bh(bh);
+		bh->added_from = _RET_IP_;
+		bh->added_jiffies = jiffies;
 		BUFFER_TRACE(bh, "added journal_head");
 	}
 	jh->b_jcount++;
@@ -2498,6 +2500,8 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
 	--jh->b_jcount;
 	if (!jh->b_jcount) {
 		__journal_remove_journal_head(bh);
+		bh->removed_from = _RET_IP_;
+		bh->removed_jiffies = jiffies;
 		jbd_unlock_bh_journal_head(bh);
 		__brelse(bh);
 	} else
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 7aa9a32..aacd1cd 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1275,6 +1275,10 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	journal = transaction->t_journal;
 	jh = jbd2_journal_grab_journal_head(bh);
 	if (!jh) {
+		printk(KERN_ERR "Dirtying buffer without jh at %lu: state %lx,"
+			"jh added from 0x%lx at %lu, removed from 0x%lx "
+			"at %lu\n", jiffies, bh->b_state, bh->removed_from,
+			bh->removed_jiffies, bh->added_from, bh->added_jiffies);
 		ret = -EUCLEAN;
 		goto out;
 	}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 91fa9a9..f24073e 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -74,6 +74,10 @@ struct buffer_head {
 	struct address_space *b_assoc_map;	/* mapping this buffer is
 						   associated with */
 	atomic_t b_count;		/* users using this buffer_head */
+	unsigned long removed_from;
+	unsigned long removed_jiffies;
+	unsigned long added_from;
+	unsigned long added_jiffies;
 };
 
 /*
-- 
1.8.1.4


--FL5UXtIhxfXey3p5--
