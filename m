From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] ext4/jbd2: Fix jbd2_journal_destory() for umount path
Date: Thu, 25 Feb 2016 21:11:19 +0800
Message-ID: <201602252133.1j77g0Iw%fengguang.wu@intel.com>
References: <87fuwh58ro.fsf@mail.parknet.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fuwh58ro.fsf@mail.parknet.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi OGAWA,

[auto build test WARNING on ext4/dev]
[also build test WARNING on v4.5-rc5 next-20160224]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/OGAWA-Hirofumi/ext4-jbd2-Fix-jbd2_journal_destory-for-umount-path/20160225-195750
base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/jbd2.h:434: warning: No description found for parameter 'i_transaction'
   include/linux/jbd2.h:434: warning: No description found for parameter 'i_next_transaction'
   include/linux/jbd2.h:434: warning: No description found for parameter 'i_list'
   include/linux/jbd2.h:434: warning: No description found for parameter 'i_vfs_inode'
   include/linux/jbd2.h:434: warning: No description found for parameter 'i_flags'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_rsv_handle'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_reserved'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_type'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_line_no'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_start_jiffies'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_requested_credits'
   include/linux/jbd2.h:490: warning: No description found for parameter 'h_lockdep_map'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_chkpt_bhs[JBD2_NR_BATCH]'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_devname[BDEVNAME_SIZE+24]'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_average_commit_time'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_min_batch_time'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_max_batch_time'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_commit_callback'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_failed_commit'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_chksum_driver'
   include/linux/jbd2.h:1033: warning: No description found for parameter 'j_csum_seed'
   include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history' description in 'journal_s'
   include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_max' description in 'journal_s'
   include/linux/jbd2.h:1033: warning: Excess struct/union/enum/typedef member 'j_history_cur' description in 'journal_s'
>> fs/jbd2/journal.c:1438: warning: No description found for parameter 'write_op'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'rsv_blocks'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'gfp_mask'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'type'
   fs/jbd2/transaction.c:429: warning: No description found for parameter 'line_no'
   fs/jbd2/transaction.c:505: warning: No description found for parameter 'type'
   fs/jbd2/transaction.c:505: warning: No description found for parameter 'line_no'
   fs/jbd2/transaction.c:635: warning: No description found for parameter 'gfp_mask'

vim +/write_op +1438 fs/jbd2/journal.c

24bcc89c Jan Kara       2012-03-13  1422  	WARN_ON(!sb->s_sequence);
f7f4bccb Mingming Cao   2006-10-11  1423  	journal->j_flags &= ~JBD2_FLUSHED;
24bcc89c Jan Kara       2012-03-13  1424  	write_unlock(&journal->j_state_lock);
6f6a6fda Joseph Qi      2015-06-15  1425  
6f6a6fda Joseph Qi      2015-06-15  1426  out:
6f6a6fda Joseph Qi      2015-06-15  1427  	return ret;
24bcc89c Jan Kara       2012-03-13  1428  }
24bcc89c Jan Kara       2012-03-13  1429  
24bcc89c Jan Kara       2012-03-13  1430  /**
24bcc89c Jan Kara       2012-03-13  1431   * jbd2_mark_journal_empty() - Mark on disk journal as empty.
24bcc89c Jan Kara       2012-03-13  1432   * @journal: The journal to update.
24bcc89c Jan Kara       2012-03-13  1433   *
24bcc89c Jan Kara       2012-03-13  1434   * Update a journal's dynamic superblock fields to show that journal is empty.
24bcc89c Jan Kara       2012-03-13  1435   * Write updated superblock to disk waiting for IO to complete.
24bcc89c Jan Kara       2012-03-13  1436   */
b16feb49 OGAWA Hirofumi 2016-02-25  1437  static void jbd2_mark_journal_empty(journal_t *journal, int write_op)
24bcc89c Jan Kara       2012-03-13 @1438  {
24bcc89c Jan Kara       2012-03-13  1439  	journal_superblock_t *sb = journal->j_superblock;
24bcc89c Jan Kara       2012-03-13  1440  
a78bb11d Jan Kara       2012-03-13  1441  	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
24bcc89c Jan Kara       2012-03-13  1442  	read_lock(&journal->j_state_lock);
eeecef0a Eric Sandeen   2012-08-18  1443  	/* Is it already empty? */
eeecef0a Eric Sandeen   2012-08-18  1444  	if (sb->s_start == 0) {
eeecef0a Eric Sandeen   2012-08-18  1445  		read_unlock(&journal->j_state_lock);
eeecef0a Eric Sandeen   2012-08-18  1446  		return;

:::::: The code at line 1438 was first introduced by commit
:::::: 24bcc89c7e7c64982e6192b4952a0a92379fc341 jbd2: split updating of journal superblock and marking journal empty

:::::: TO: Jan Kara <jack@suse.cz>
:::::: CC: Theodore Ts'o <tytso@mit.edu>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--DocE+STaALJfprDB
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
QCu8MvmbiV0Wgv8xDHOdSlgAAA==

--DocE+STaALJfprDB--
