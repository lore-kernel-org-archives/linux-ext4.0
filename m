From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 0/7] Simplify buffered write submissions, part II
Date: Sat, 12 Feb 2011 19:15:50 -0500
Message-ID: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38171 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab1BMA5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:57:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This has been a background project I've been working on for the past
couple of weeks.  It cleans up middle part of the buffered write pages a
bit.  The main features of this patch are:

*) Every single patch removes more lines of code than it adds, with a
	net total removal of nearly 100 lines of code from fs/ext4/inode.c
*) The ext4_da_writepages() codepath no longer abuses the
	clear_page_dirty_for_io() function, which means we no longer
	need to call redirty_page_for_writeback().  This removes
	unneeded work, which is goodness.
*) We no longer start journal handles if they are not needed.  This
	should improve performance and improve SMP scalability on
	parallel random write workloads when the journal is enabled
	in the best way possible --- don't take locks when they aren't
	needed!   

There is still more cleanup that needs to be done, but since these
patches should improve performance by themselves, it seems worthwhile
for me to send these out as-is, and ask people to take a look.  What do
you guys think?

					- Ted

Theodore Ts'o (7):
  ext4: fold __mpage_da_writepage() into write_cache_pages_da()
  ext4: simple cleanups to write_cache_pages_da()
  ext4: clear the dirty bit for a page in writeback at the last minute
  ext4: remove page_skipped hackery in ext4_da_writepages()
  ext4: don't lock the next page in write_cache_pages if not needed
  ext4: move setup of the mpd structure to write_cache_pages_da()
  ext4: move ext4_journal_start/stop to mpage_da_map_and_submit()

 fs/ext4/ext4.h  |    3 +-
 fs/ext4/inode.c |  428 +++++++++++++++++++++----------------------------------
 2 files changed, 167 insertions(+), 264 deletions(-)

-- 
1.7.3.1

