From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Questions about mballoc's stream allocation
Date: Fri, 07 Aug 2009 09:07:53 -0400
Message-ID: <E1MZPAn-0001Y0-TQ@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60824 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZHGNH5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2009 09:07:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've got two questions about mballoc's stream allocation.

First of all, in ext4_mb_regular_allocator(), I'm 99% sure this is a
bug:

	/* if stream allocation is enabled, use global goal */
	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
	isize = i_size_read(ac->ac_inode) >> bsbits;
	if (size < isize)
		size = isize;

	if (size < sbi->s_mb_stream_request &&
	    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			(ac->ac_flags & EXT4_MB_HINT_DATA)) {
		/* TBD: may be hot point */
		spin_lock(&sbi->s_md_lock);
		ac->ac_g_ex.fe_group = sbi->s_mb_last_group;
		ac->ac_g_ex.fe_start = sbi->s_mb_last_start;
		spin_unlock(&sbi->s_md_lock);
	}

Shouldn't that be ">=", not "<".  We want to use the values saved in
sbi->s_mb_last_{group,start} only if we are doing a stream allocation,
which would be true only if the file is *larger* than
s_mb_stream_request, no?


The second question I have is with regards to ext4_mb_use_best_found(),
we set sbi->s_mb_last_{group,start} on any data allocation; shouldn't we
only be setting those values only if we were doing a stream allocation
in the first place?

Otherwise, any kind of allocation will end up moving the global goal
block for stream allocations; even if it is a small allocation in the
middle of some block group caused by the flag EXT4_MB_HINT_NO_PREALLOC
being set.

Am I missing anything?

     	   	      	       		     - Ted
