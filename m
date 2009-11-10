From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4]ext4: Fix lock order problem in ext4_move_extents()
Date: Tue, 10 Nov 2009 16:53:38 -0500
Message-ID: <20091110215338.GD13262@mit.edu>
References: <4AEA98C4.3070907@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55443 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758328AbZKJVxf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2009 16:53:35 -0500
Content-Disposition: inline
In-Reply-To: <4AEA98C4.3070907@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 30, 2009 at 04:41:56PM +0900, Akira Fujita wrote:
> ext4: Fix lock order problem in ext4_move_extents()
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, I've added this to the ext4 patch queue with the updated
commit description:

ext4: Fix lock order problem in ext4_move_extents()

From: Akira Fujita <a-fujita@rs.jp.nec.com>

ext4_move_extents() checks the logical block contiguousness
of original file with ext4_find_extent() and mext_next_extent().
Therefore the extent which ext4_ext_path structure indicates
must not be changed between above functions.

But in current implementation, there is no i_data_sem protection
between ext4_ext_find_extent() and mext_next_extent().  So the extent
which ext4_ext_path structure indicates may be overwritten by
delalloc.  As a result, ext4_move_extents() will exchange wrong blocks
between original and donor files.  I change the place where
acquire/release i_data_sem to solve this problem.

Moreover, I changed move_extent_per_page() to start transaction first,
and then acquire i_data_sem.  Without this change, there is a
possibility of the deadlock between mmap() and ext4_move_extents():

* NOTE: "A", "B" and "C" mean different processes

A-1: ext4_ext_move_extents() acquires i_data_sem of two inodes.

B:   do_page_fault() starts the transaction (T),
     and then tries to acquire i_data_sem.
     But process "A" is already holding it, so it is kept waiting.

C:   While "A" and "B" running, kjournald2 tries to commit transaction (T)
     but it is under updating, so kjournald2 waits for it.

A-2: Call ext4_journal_start with holding i_data_sem,
     but transaction (T) is locked.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
