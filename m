From: Jan Kara <jack@suse.cz>
Subject: Re: next-20090310: ext4 hangs
Date: Tue, 31 Mar 2009 14:33:07 +0200
Message-ID: <20090331123307.GG11808@duck.suse.cz>
References: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com> <20090325152234.GN23439@duck.suse.cz> <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com> <20090325161556.GP23439@duck.suse.cz> <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com> <20090325194316.GQ23439@duck.suse.cz> <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com> <20090331100150.GF11808@duck.suse.cz> <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Transfer-Encoding: 8bit
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51922 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZCaMdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:33:11 -0400
Content-Disposition: inline
In-Reply-To: <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue 31-03-09 14:07:30, Alexander Beregalov wrote:
> 2009/3/31 Jan Kara <jack@suse.cz>:
> > On Thu 26-03-09 01:38:32, Alexander Beregalov wrote:
> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> > On Wed 25-03-09 20:07:46, Alexander Beregalov wrote:
> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> >> > On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
> >> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> >> >> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
> >> >> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> >> >> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
> >> >> >> >> >>   I've looked into this. Obviously, what's happenning is that we delete
> >> >> >> >> >> an inode and jbd2_journal_release_jbd_inode() finds inode is just under
> >> >> >> >> >> writeout in transaction commit and thus it waits. But it gets never woken
> >> >> >> >> >> up and because it has a handle from the transaction, every one eventually
> >> >> >> >> >> blocks on waiting for a transaction to finish.
> >> >> >> >> >>   But I don't really see how that can happen. The code is really
> >> >> >> >> >> straightforward and everything happens under j_list_lock... Strange.
> >> >> >> >> >  BTW: Is the system SMP?
> >> >> >> >> No, it is UP system.
> >> >> >> >  Even stranger. And do you have CONFIG_PREEMPT set?
> >> >> >> >
> >> >> >> >> The bug exists even in 2.6.29, I posted it with a new topic.
> >> >> >> >  OK, I've sort-of expected this.
> >> >> >>
> >> >> >> CONFIG_PREEMPT_RCU=y
> >> >> >> CONFIG_PREEMPT_RCU_TRACE=y
> >> >> >> # CONFIG_PREEMPT_NONE is not set
> >> >> >> # CONFIG_PREEMPT_VOLUNTARY is not set
> >> >> >> CONFIG_PREEMPT=y
> >> >> >> CONFIG_DEBUG_PREEMPT=y
> >> >> >> # CONFIG_PREEMPT_TRACER is not set
> >> >> >>
> >> >> >> config is attached.
> >> >> >  Thanks for the data. I still don't see how the wakeup can get lost. The
> >> >> > process even cannot be preempted when we are in the section protected by
> >> >> > j_list_lock... Can you send me a disassembly of functions
> >> >> > jbd2_journal_release_jbd_inode() and journal_submit_data_buffers() so that
> >> >> > I can see whether the compiler has not reordered something unexpectedly?
> >> >  Thanks for the disassembly...
> >> >
> >> >> By default gcc inlines journal_submit_data_buffers()
> >> >> Here is -fno-inline version. Default version is in attach.
> >  <snip>
> >
> >  I'm helpless here. I don't see how we can miss a wakeup (plus you seem to
> > be the only one reporting the bug). Could you please compile and test the kernel
> > with the attached patch? It will print to kernel log when we go to sleep
> > waiting for inode commit and when we send wakeups etc. When you hit the
> > deadlock, please send me your kernel log. It should help with debugging why do
> > we miss the wakeup. Thanks.
> 
> Which patch?
  Ups. Forgot to attach ;).

										Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--d6Gm4EdcadzBjdND
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Debug-sleepers-in-iput.patch"

>From 123ab7510c04c698077e5756b4de6c66ce8ee71e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 31 Mar 2009 11:57:10 +0200
Subject: [PATCH] ext4: Debug sleepers in iput()

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c  |    4 ++++
 fs/jbd2/journal.c |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 62804e5..f47b8a3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -259,6 +259,8 @@ static int journal_submit_data_buffers(journal_t *journal,
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		if (jinode->i_flags & 4)
+			printk(KERN_INFO "JBD2: Waking up sleeper on ino %lu\n", jinode->i_vfs_inode->i_ino);
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 	spin_unlock(&journal->j_list_lock);
@@ -296,6 +298,8 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 		}
 		spin_lock(&journal->j_list_lock);
 		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		if (jinode->i_flags & 4)
+			printk(KERN_INFO "JBD2: Waking up sleeper on ino %lu\n", jinode->i_vfs_inode->i_ino);
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5814410..5459fd9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2225,11 +2225,17 @@ restart:
 	if (jinode->i_flags & JI_COMMIT_RUNNING) {
 		wait_queue_head_t *wq;
 		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
+		unsigned long ino = jinode->i_vfs_inode->i_ino;
+
+		jinode->i_flags |= 4;
+		printk(KERN_INFO "JBD2: Waiting for ino %lu\n", ino);
+
 		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
 		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock(&journal->j_list_lock);
 		schedule();
 		finish_wait(wq, &wait.wait);
+		printk(KERN_INFO "JBD2: Woken on ino %lu\n", ino);
 		goto restart;
 	}
 
-- 
1.6.0.2


--d6Gm4EdcadzBjdND--
