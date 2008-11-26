From: Mingming Cao <cmm@us.ibm.com>
Subject: jbd commit data buffers EIO error
Date: Tue, 25 Nov 2008 16:18:05 -0800
Message-ID: <1227658685.6476.26.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Eric Sandeen <esandeen@redhat.com>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:59687 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYKZASG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 19:18:06 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAQ0HQLG015067
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 17:17:26 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAQ0I52r128408
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 17:18:05 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAQ0I4lT015932
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 17:18:05 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric and I are looking at an EIO error in journal_submit_data_buffers()
in commit.c

If the buffer is unlocked and not dirty,  journal_submit_data_buffers()
would assume someboday else (pdflush) would already flushed the dirty
data to disk. Now it checks the buffer's uptodate bit,  try to catch the
disk IO if the buffer is submitted by pdflush. This behavior is
introduced with
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=cbe5f466f6995e10a10c7ae66d6dc8608f08a6b8

We consistantly hit this EIO on blocksize<pagesize case, on multiple
arch (ppc64, x86 with 1k blk size) with fsstress test, where there is no
real disk io error

journal_submit_data_buffers() in commit.c

                } else if (!locked && buffer_locked(bh)) {
                        __journal_file_buffer(jh, commit_transaction,
                                                BJ_Locked);
                        jbd_unlock_bh_state(bh);
                        put_bh(bh);
                } else {
                        BUFFER_TRACE(bh, "writeout complete: unfile");
                        if (unlikely(!buffer_uptodate(bh)))
------->                err = -EIO;
                        __journal_unfile_buffer(jh);
                        jbd_unlock_bh_state(bh);
                        if (locked)
                                unlock_buffer(bh);
                        journal_remove_journal_head(bh);
                        /* One for our safety reference, other for
                         * journal_remove_journal_head() */
                        put_bh(bh);
                        release_data_buffer(bh);
                }

And print out false warning message:

JBD: Detected IO errors while flushing file data on sdb4

The buffer head was attached to the sync_data_list from
ext3_ordered_writepage()->journal_dirty_data_fn on every buffer heads of
that dirty page, but I saw many many cases that the buffer is not dirty
but still added to the journal dirty data buffer list(when block size <
pagesize). Is this the right thing to do? If the attached buffer is not
dirty, why  jbd still need to keep track of it?

In the fsstress test case, the debug info shows  the buffers attached to
sync_data_list originally could be mapped & not dirty & not uptodate
&not locked.  (not sure what kind of bh in that state? ) That will
confuse journal_submit_data_buffers() and returns with false EIO alert
(as the bh is !uptodate)

Adding a hack in journal_dirty_data_fn() to check buffer dirty bit fixed
the false alert issue. It seems too easy, so I want to make sure whether
that's the right thing to do.


Thanks,
Mingming

