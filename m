From: Jan Kara <jack@suse.cz>
Subject: Re: Bug#615998: linux-image-2.6.32-5-xen-amd64: Repeatable "kernel
 BUG at fs/jbd2/commit.c:534" from Postfix on ext4
Date: Thu, 1 Sep 2011 17:17:44 +0200
Message-ID: <20110901151744.GA2070@quack.suse.cz>
References: <AF621113-8320-4973-A88A-1FC048EA4293@boeing.com>
 <BANLkTi=5BLA07tvbv3PFcZ0cc8FmBtg+UA@mail.gmail.com>
 <404FD5CC-8F27-4336-B7D4-10675C53A588@boeing.com>
 <20110624134659.GB26380@quack.suse.cz>
 <2F80BF45-28FA-46D3-9A28-CA9416DC5813@boeing.com>
 <20110624200231.GA32176@quack.suse.cz>
 <5DE8D448-A77D-46E8-BF40-15AA7F7CDBE9@boeing.com>
 <79E8C04C-B5A8-49E5-901F-444C8B8A53DB@boeing.com>
 <20110830221249.GH16202@quack.suse.cz>
 <F33B5C17-2893-44D4-BBE4-C75CDC1375EA@boeing.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Cc: Jan Kara <jack@suse.cz>, Sean Ryle <seanbo@gmail.com>,
	Ted Ts'o <tytso@mit.edu>,
	"615998@bugs.debian.org" <615998@bugs.debian.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Sachin Sant <sachinp@in.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab1IAPR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 11:17:57 -0400
Content-Disposition: inline
In-Reply-To: <F33B5C17-2893-44D4-BBE4-C75CDC1375EA@boeing.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 30-08-11 19:26:22, Moffett, Kyle D wrote:
> On Aug 30, 2011, at 18:12, Jan Kara wrote:
> >> I can still trigger it on my VM snapshot very easily, so if you have anything
> >> you think I should test I would be very happy to give it a shot.
> > 
> >  OK, so in the meantime I found a bug in data=journal code which could be
> > related to your problem. It is fixed by commit
> > 2d859db3e4a82a365572592d57624a5f996ed0ec which is in 3.1-rc1. Have you
> > tried that or newer kernel as well?
> > 
> > If the problem still is not fixed, I can provide some debugging patch to
> > you. We spoke with Josef Bacik how errors like yours could happen so I have
> > some places to watch...
> 
> I have not tried anything more recent; I'm actually a bit reluctant to move
> away from the Debian squeeze official kernels since I do need the security
> updates.
> 
> I took a quick look and I can't find that function in 2.6.32, so I assume it
> would be a rather nontrivial back-port.  It looks like the relevant code
> used to be in ext4_clear_inode somewhere?
  It's not that hard - untested patch attached.

> Out of curiosity, what would happen in data=journal mode if you unlinked a
> file which still had buffers pending?  That case does not seem to be handled
> by that commit you mentioned, was it already handled elsewhere?
  Once the file is deleted, it's OK to discard its data after a
transaction doing delete commits. The current code in JBD2 handles this
case fine - the problem was that for not-deleted files we cannot discard
dirty data after a transaction commits ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--LZvS9be/3tNcYl/X
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-2.6.32-data-journal-corruption.diff"

diff -rupX /crypted/home/jack/.kerndiffexclude linux-2.6.32.orig//fs/ext4/inode.c linux-2.6.32-ext4_fix//fs/ext4/inode.c
--- linux-2.6.32.orig//fs/ext4/inode.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-ext4_fix//fs/ext4/inode.c	2011-09-01 17:15:39.742361528 +0200
@@ -1794,6 +1794,7 @@ static int ext4_journalled_write_end(str
 	if (new_i_size > inode->i_size)
 		i_size_write(inode, pos+copied);
 	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
+	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
 	if (new_i_size > EXT4_I(inode)->i_disksize) {
 		ext4_update_i_disksize(inode, new_i_size);
 		ret2 = ext4_mark_inode_dirty(handle, inode);
@@ -2630,6 +2631,7 @@ static int __ext4_journalled_writepage(s
 				write_end_fn);
 	if (ret == 0)
 		ret = err;
+	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
diff -rupX /crypted/home/jack/.kerndiffexclude linux-2.6.32.orig//fs/ext4/super.c linux-2.6.32-ext4_fix//fs/ext4/super.c
--- linux-2.6.32.orig//fs/ext4/super.c	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32-ext4_fix//fs/ext4/super.c	2011-09-01 17:13:55.379363889 +0200
@@ -759,6 +759,40 @@ static void ext4_clear_inode(struct inod
 				       &EXT4_I(inode)->jinode);
 }
 
+static void ext4_drop_inode(struct inode *inode)
+{
+	if (inode->i_nlink) {
+		/*
+		 * When journalling data dirty buffers are tracked only in the
+		 * journal. So although mm thinks everything is clean and
+		 * ready for reaping the inode might still have some pages to
+		 * write in the running transaction or waiting to be
+		 * checkpointed. Thus calling jbd2_journal_invalidatepage()
+		 * (via truncate_inode_pages()) to discard these buffers can
+		 * cause data loss. Also even if we did not discard these
+		 * buffers, we would have no way to find them after the inode
+		 * is reaped and thus user could see stale data if he tries to
+		 * read them before the transaction is checkpointed. So be
+		 * careful and force everything to disk here... We use
+		 * ei->i_datasync_tid to store the newest transaction
+		 * containing inode's data.
+		 *
+		 * Note that directories do not have this problem because they
+		 * don't use page cache.
+		 */
+		if (ext4_should_journal_data(inode) &&
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
+
+			jbd2_log_start_commit(journal, commit_tid);
+			jbd2_log_wait_commit(journal, commit_tid);
+			filemap_write_and_wait(&inode->i_data);
+		}
+	}
+	generic_drop_inode(inode);
+}
+
 static inline void ext4_show_quota_options(struct seq_file *seq,
 					   struct super_block *sb)
 {
@@ -1029,6 +1063,7 @@ static const struct super_operations ext
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
 	.clear_inode	= ext4_clear_inode,
+	.drop_inode	= ext4_drop_inode,
 	.show_options	= ext4_show_options,
 #ifdef CONFIG_QUOTA
 	.quota_read	= ext4_quota_read,

--LZvS9be/3tNcYl/X--
