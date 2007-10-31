From: Jan Kara <jack@suse.cz>
Subject: Re: a potential deadlock?
Date: Wed, 31 Oct 2007 20:27:16 +0100
Message-ID: <20071031192716.GE28809@atrey.karlin.mff.cuni.cz>
References: <002701c8179c$cc3a02b0$64ae0810$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: LIOU Payphone <lioupayphone@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36539 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXJaT1S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2007 15:27:18 -0400
Content-Disposition: inline
In-Reply-To: <002701c8179c$cc3a02b0$64ae0810$@com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

> Here is a question to be confirmed.
> 
> In ext3_ioctl() with "cmd == EXT3_IOC_SETFLAGS", we firstly lock
> "inode->i_mutex", start a handle with 1 journal-block by calling
> ext3_journal_start(). In ext3_new_blocks(), say QUOTA was enabled with vfsv0
> format, we will call the function "DQUOT_ALLOC_BLOCK()". The handle in
> ext3_new_blocks()  was started by high-level functions, and
> DQUOT_ALLOC_BLOCK() will finally calles ext3_quota_write() in which it try
> to lock the "i_mutex" of the inode of a quota-file. 
> 
> At it happens, when we want to modify the inodes of quota-files via
> ext3_ioctl(cmd = EXT3_IOC_SETFLAGS) (say process-A), another guy try to
> execute ext3_quota_write() by calling DQUOT_ALLOC_BLOCK() (say process-B). I
> guess a potential deadlock between process-A and process-B would happen in
> such a executing sequence:
> 
> (1) process-B got many journal-blocks, then came into ext3_new_blocks(),
> hung up
> (2) process-A locked i_mutex of the inode of a quota-file, then try to
> starts a handle. Unfortunately, there are no enough journal-blocks left for
> process-A.
> (3) process-B awakened, and came into DQUOT_ALLOC_BLOCK(), finally came into
> the function ext3_quota_write() who also wants to lock the i_mutex of the
> inode of a quota-file. But the i_mutex was locked by process-A. so process-B
> has no choice but to wait.
> (4) if the ext3-filesystem was  too busy to release jounal-blocks for
> process-A, or a unexpected incident happened. Both  the two situations would
> result in no journal-blocks for any other processes. Apparently, process-A
> have to wait for available journal-blocks. so process-A was hung-up with
> i_mutex of the inode of a quota-file locked.
> (5) process-B was blocked by the "inode->i_mutex" subsequently.
  Yes, that is a lock inversion between the journal lock and i_mutex on
quota files which can indeed lead to a deadlock. Thanks for spotting it.
Luckily it's not very likely you're going to hit it but we should fix it
anyway. Currently I don't have much idea how - probably we'd have to get
rid of the need to use i_mutex on quota files in quota_write but that's
also non-trivial.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
