From: Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 08 Sep 2009 08:41:05 -0700
Message-ID: <1252424465.17646.7.camel@bobble.smo.corp.google.com>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
	 <20090908050614.GA10477@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:13808 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZIHPlH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 11:41:07 -0400
In-Reply-To: <20090908050614.GA10477@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-09-08 at 01:06 -0400, Theodore Tso wrote:
> On Fri, Sep 04, 2009 at 07:55:00PM -0700, Frank Mayhar wrote:
> > Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> > mode:  If we're not using a journal, ext4_write_inode() now calls
> > ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> > with a new "do_sync" parameter.  If that parameter is nonzero
> > ext4_do_update_inode() calls sync_dirty_buffer() instead of
> > ext4_handle_dirty_metadata().
> 
> Hi Frank,
> 
> The problem with this patch is that it's only safe to call
> sync_dirty_buffer() if we are not journalling.  If we are using the
> journal, we must *not* call sync_dirty_buffer(), but instead must use
> jbd2_journal_dirty_metadata().
> 
> The problem is that there are paths where ext4_do_update_inode() can
> get called with do_sync==1, even when journalling is enabled.
> Specifically, if ext4_write_inode() is called with wait==1, wait is
> passed to ext4_do_update_inode() as do_sync, and then when a journal
> is present, we will end up calling sync_dirty_buffer(), which means we
> will be writing out the modified metadata *before* the transaction has
> committed.

I needed to doublecheck before answering but I think I've covered that
angle.  Specifically, in ext4_write_inode the patch only calls
ext4_do_update_inode() if s_journal is NULL, otherwise it takes the
current path.

So I think your concern is covered by the current patch.  Can you take
another look and let me know if you agree?  Thanks.

> I think what you need to do instead is to add an extra parameter
> do_sync to ext4_handle_dirty_metadata(), and continue to call
> ext4_handle_dirty_metadata.  However in code paths where we will later
> force a commit to guarantee that the metadata has been written out
> (i.e., in the fsync() code path), ext4_handle_dirty_metadata() should
> be called with the new do_sync parameter set to 1.
> 
> Does that make sense?

Actually, yes it does (my above comment notwithstanding) and I
considered that approach.  Unfortunately, as Curt pointed out, there are
a metric buttload of calls to ext4_handle_dirty_metadata().  The "right"
way to fix this might be to change all of them and use
handle_dirty_metadata to deal with this but it seems like an awfully
intrusive change to fix this one problem.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

