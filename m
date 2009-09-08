From: Jan Kara <jack@suse.cz>
Subject: fsync on ext[34] working only by an accident
Date: Tue, 8 Sep 2009 15:26:01 +0200
Message-ID: <20090908132601.GA17778@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38484 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZIHN0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 09:26:00 -0400
Received: from relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 105CC8E8CC
	for <linux-ext4@vger.kernel.org>; Tue,  8 Sep 2009 15:26:03 +0200 (CEST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  When looking at how ext3/4 handles fsync, I've realized I don't
understand how writing out inode on fsync can work. The problem is that
ext3/4 mostly calls ext?_mark_inode_dirty() which actually does *not* dirty
the inode. It just copies the in-memory inode content to disk buffer.
So in particular the inode looks clean to VFS and our check in
ext?_sync_file() shouldn't trigger.
  The only obvious case when we call mark_inode_dirty() is from write_end
functions when we update i_size but that's clearly not enough. Now I did
some research why things seem to be actually working. The trick is that
when allocating block, we call vfs_dq_alloc_block() which calls
mark_inode_dirty(). But that's all what's keeping our fsync / writeout
logic from breaking!
  There are even some cases when the logic actually is broken (I've tested
it and it really does not work) - for example when you create an empty
file, the inode won't get written when you fsync it.
  So what we should IMHO do is to convert all ext?_mark_inode_dirty()
calls to simple mark_inode_dirty() (or even maybe introduce and use
mark_inode_dirty_datasync() where appropriate). It will cost us some more
CPU and stack space but if we optimize ext3_dirty_inode() for the case
where handle is already started, it shouldn't be too bad.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
