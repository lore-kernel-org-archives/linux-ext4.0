From: "Theodore Ts'o" <tytso@mit.edu>
Subject: The meaning of data=ordered as it relates to delayed allocation
Date: Sun, 18 Jan 2009 19:52:10 -0500
Message-ID: <E1LOiN8-0001Cj-91@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54556 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438AbZASAwN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 19:52:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


An Ubuntu user recently complained about a large number of recently
updated files which were zero-length after an crash.  I started looking
more closely at that, and it's because we have an interesting
interpretation of data=ordered.  It applies for blocks which are already
allocated, but not for blocks which haven't been allocated yet.  This
can be surprising for users; and indeed, for many workloads where you
aren't using berk_db some other database, all of the files written will 
be newly created files (or files which are getting rewritten after
opening with O_TRUNC), so there won't be any difference between
data=writeback and data=ordered.

So I wonder if we should either:

(a) make data=ordered force block allocation and writeback --- which
    should just be a matter of disabling the
    redirty_page_for_writepage() code path in ext4_da_writepage()

(b) add a new mount option, call it data=delalloc-ordered which is (a)

(c) change the default mount option to be data=writeback

(d) Do (b) and make it the default

(e) Keep things the way they are

Thoughts, comments?   My personal favorite is (b).   This allows users
who want something that works functionally much more like ext3 to get
that, while giving us the current speed advantages of a more aggressive
delayed allocation.

						- Ted
