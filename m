From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] jbd2: Avoid unnecessary locking when buffer is already journaled
Date: Thu,  2 Apr 2015 15:58:15 +0200
Message-ID: <1427983100-29889-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbbDBN61 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 09:58:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this patch set improves do_get_write_access(), jbd2_journal_get_undo_access(),
and jbd2_journal_dirty_metadata() to be completely lockless in case buffer
is already part of an appropriate journalling list. First three patches
are independent small cleanups so they can go in right away I think.

The other two patches *should* improve the situation for frequent bitmap
or inode table block updates. But frankly, I haven't been able to come up
with a load where I'd see significant contention on update of a single buffer
(or it's hidden by a larger lock). Similarly we could see improvements when
do_get_write_access() would be waiting for buffer lock because buffer is
being written out by checkpointing code. But again I wasn't able to hit this
reliably.

Ted, you mentioned at Vault you had a setup where frequent
do_get_write_access() calls were contending in the revoke code. What was the
load exactly? These patches should improve that as well...

								Honza
