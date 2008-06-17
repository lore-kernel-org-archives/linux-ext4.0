From: Jan Kara <jack@suse.cz>
Subject: Re: one question about jbd, please look into it
Date: Tue, 17 Jun 2008 14:42:16 +0200
Message-ID: <20080617124216.GC12527@duck.suse.cz>
References: <200806171709232032422@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dingdinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35466 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756327AbYFQMmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2008 08:42:18 -0400
Content-Disposition: inline
In-Reply-To: <200806171709232032422@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Tue 17-06-08 17:09:26, dingdinghua wrote:
>      I'm a graduate student from china, I have a question about JBD, my
>      kernel version is 2.6.17, and our jbd version is some version
>      between jbd and jbd2, since I only need the 64bit-bno feature, jbd
>      was not fully patched to jbd2.  My question is, "what will happen if
>      too many block need revoke in a transaction" or "can this situation
>      happen?" In order to investigate it, I did an experiment, I modified
  Hmm, in theory you are right that this could happen, in practice it does
not because if we delete metadata blocks (or directory blocks), we modify
them before. Hence, because number of blocks in a transaction is limited,
the number of revoke records is limited as well and fits into the safety
margin...

>      ext3 as follows:
> 
> fs/ext3/inode.c >> ext3_forget
> 
> <       if (test_opt(inode->i_sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ||
> <        (!is_metadata && !ext3_should_journal_data(inode))) {
> ---
> >       //if (test_opt(inode->i_sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ||
> >        if(!is_metadata && !ext3_should_journal_data(inode)) { 
  Yes, after this modification you may be able to trigger the problem - but
note that when everything is journaled no revoke records are needed (they
are only needed because some block can contain journaled metadata and later
be reallocated for non-journaled data).

>      I mount a partition as ext3, using data=journal mode, then we create
>      a reg file, about 2G, when unlinking the file, jbd will get into
>      mistake, the log:
> 
>  Assertion failure in journal_next_log_block() at fs/jbd/journal.c:561: "journal->j_free > 1"
  <snip>

>      This situation(i don't know if it can be called "bug") can easily
>      reappear in situation above.  When I read jbd code,  I found that
>      jbd doesn't make any guarantee that there are enough block in
>      jornal-device which can be used as revoke block. The major job
>      "journal_revoke" do is insert [sequence, blocknr] into hash link,
>      when this transaction commit, the entries in hash link will be
>      flushed to journal by "journal_write_revoke_records", this function
>      call "write_one_revoke_record", then "journal_get_descriptor_buffer"
>      when needing an new block, then "journal_next_log_block", since jbd
>      can't guarantee there are enough block, assertion
>      J_ASSERT(journal->j_free > 1); may fail, just as the log above.
>      Certainly, If I haven't modified the ext3 code, this situation
>      couldn't happen, but what about remove a very large directory?
  Yes, as I wrote above, you are right that there's a gap. Maybe with big
enough directory you may be able to trigger the problem. The question is
how to fix this without a too big hassle. Probably we should account for
revoke record block when requesting credits for a handle in
journal_start(), track number of revokes already added by a handle and
account for credits really used by revoke blocks so that we don't return
them on journal_stop(). This should be reasonably easy. Will you do the
fix?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
