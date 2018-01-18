From: Jan Kara <jack@suse.cz>
Subject: Failure with generic/388 test
Date: Thu, 18 Jan 2018 18:39:46 +0100
Message-ID: <20180118173946.aug2x2iclhemeij6@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33244 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754930AbeARRjs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 Jan 2018 12:39:48 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I've been seeing failures with generic/388 test (with 4.12-based distro
kernel). Now after debugging it for some time it seems it is a problem in
EXT4_GOING_FLAGS_NOLOGFLUSH implementation. What seems to be happening is
that e.g. directory is being created, we set EXT4_FLAGS_SHUTDOWN in the
middle and so the creation fails. We do iput() which should delete the
unused inode but since the filesystem is marked as EXT4_FLAGS_SHUTDOWN,
those changes don't hit the disk. *But* the transaction which has allocated
the inode still manages to commit before we abort the journal (as there is
a window provided by msleep() in EXT4_GOING_FLAGS_NOLOGFLUSH
implementation). So after journal recovery, we have unattached inode and
e2fsck complains.

Now this would not happen if the system just crashed - in such case, either
the allocating transaction won't be able to commit, or iput() would have
finished successfully and logged inode deletion in the same transaction.

So why is journal abort happening after EXT4_FLAGS_SHUTDOWN being set and
why is that window even prolonged by msleep? That would deserve a comment
if nothing else BTW...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
