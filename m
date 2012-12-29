From: Theodore Ts'o <tytso@mit.edu>
Subject: notes in the WARN_ON in ext4_release_page() with data=journal
Date: Sat, 29 Dec 2012 02:58:54 -0500
Message-ID: <nsxsj6pe1c1.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40787 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2L2H65 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 02:58:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've been trying to track down with a WARN_ON in ext4_release_page()
which can be reproduced by running xfstests #247 in data=journalled
mode.  I'm sending the results of this investigation to linux-ext4
partially as a note to myself, or in case other people notice it.

What's going on is while the O_DIRECT write is happening, in
generic_file_direct_write(), first we force all of the pages in question
to disk using filemap_write_and_wait_range().  Then, we invalidate all
of the pages in question.  If there is a process which is also modifying
the page using mmap writes (which is the case in test #247), the page
can get marked dirty after its writeback, and before the pages are
released by invalidate_inode_pages2_range().

(The PageChecked flag is set by ext4_journalled_set_page_dirty(), and
cleared by __ext4_journalled_writepage() --- for an explanation why,
please see comments for __ext4_journalled_writepage().  When the page
gets released, if ext4_release_page() notices that the PageChecked flag
is still set, it will trigger the WARN_ON.)

This WARN_ON(), then since the stack trace involves
invalidate_page_range(), is harmless.  If the user is doing unaligned
DIO writes, the changes made by the mmap might disappear, and which
means our cache coherency guarantees made by our O_DIRECT guarantee is
not absolute.  I'm not really worried about it since, if an application
is racing an mmap modification with an O_DIRECT write, it's just asking
to lose --- and this race has been there for a long time.  It's just
that the data=journal machinery makes this noticeable.

                                           - Ted
