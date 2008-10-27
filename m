From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: general protection fault:  from release_blocks_on_commit
Date: Mon, 27 Oct 2008 17:26:47 -0500
Message-ID: <49064027.9010509@redhat.com>
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYJ0W1U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 18:27:20 -0400
In-Reply-To: <20081027181928.GB23111@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> On Tue, Oct 21, 2008 at 02:03:01PM -0400, Eric Paris wrote:
>   
>> I can consistently get the below backtrace any time I try to shutdown my
>> machine.  This machine has ext4 as it's root FS.  This is 100%
>> reproducible.  I backed out commit
>> 3e624fc72fba09b6f999a9fbb87b64efccd38036 and it fixed the problem.
>>
>> This is a regression.
>>     
>
> Can you send me your .config, please?  I'm trying to duplicate it on
> my end.  
>
> 						- Ted
>   
Ted, you probably need some slab debugging on to hit it.

I think the problem is that jbd2_journal_commit_transaction may call
__jbd2_journal_drop_transaction(journal, commit_transaction) if the
checkpoint lists are NULL, and this frees the commit_transaction.

However, the call to ->j_commit_callback() tries to use it after that.

I'm out of time for now to be sure this is the right fix, but something
like this perhaps?

Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c	2008-10-27 11:24:42.000000000 -0500
+++ linux-2.6/fs/jbd2/commit.c	2008-10-27 17:19:22.771063324 -0500
@@ -992,15 +992,15 @@ restart_loop:
 			commit_transaction->t_cpprev->t_cpnext =
 				commit_transaction;
 		}
+		if (journal->j_commit_callback)
+			journal->j_commit_callback(journal, commit_transaction);
+
+		trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
+			   journal->j_devname, commit_transaction->t_tid,
+			   journal->j_tail_sequence);
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	if (journal->j_commit_callback)
-		journal->j_commit_callback(journal, commit_transaction);
-
-	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
-		   journal->j_devname, commit_transaction->t_tid,
-		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 

Also, I'm not certain that it matters, but the loop in 
release_blocks_on_commit() is kfreeing list entries w/o taking
them off the list; I suppose maybe this is safe if the whole thing
is getting discarded when we're done, but just to keep things sane,
would this make sense (also, I think we need to double-check use of
s_md_lock; it's taken when adding things to the list, but not when
freeing/removing ... if it's needed, isn't it needed on both ends...):


Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2008-10-27 11:24:41.000000000 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2008-10-27 17:19:43.401064490 -0500
@@ -2644,6 +2644,7 @@ static void release_blocks_on_commit(jou
 	struct super_block *sb = journal->j_private;
 	struct ext4_buddy e4b;
 	struct ext4_group_info *db;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int err, count = 0, count2 = 0;
 	struct ext4_free_data *entry;
 	ext4_fsblk_t discard_block;
@@ -2683,6 +2684,9 @@ static void release_blocks_on_commit(jou
 			   (unsigned long long) discard_block, entry->count);
 		sb_issue_discard(sb, discard_block, entry->count);
 
+		spin_lock(&sbi->s_md_lock);
+		list_del(&entry->list);
+		spin_unlock(&sbi->s_md_lock);
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
 	}

-Eric

