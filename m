From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 17 Jun 2008 08:03:56 -0400
Message-ID: <20080617120356.GB12448@mit.edu>
References: <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu> <20080524235420.GD5970@mit.edu> <20080603024037.GL23119@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52488 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757693AbYFQMEB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Jun 2008 08:04:01 -0400
Content-Disposition: inline
In-Reply-To: <20080603024037.GL23119@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here are the topics that have been cooking.  Commits prefixed
with '-' are only in 'pu' while commits prefixed with '+' are
in 'next'.  The topics list the commits in reverse chronological
order.

* js/64-bit (Wed May 21 12:54:28 2008 -0500) 11 commits
 - Add 64-bit openfs interface
 - Use new ext2fs_super_and_bgd_loc2 call in libext2fs
 - Add 64-bit closefs interface
 - Add 64-bit ext_attr interface
 - Add 64-bit alloc interface
 - Add 64-bit alloc_stats interface
 - Add 64-bit dirblock interface
 - Use blk64_t for blocks in struct ext2_file
 - libext2fs: Add 64-bit support to the undo manager
 - Add new blk64_t handling functions
 - Add ext2_off64_t type

	I've massaged the patch comments to avoid duplication, and
	applied Jose's fix to the 64-bit alloc interface patch, which
	had been badly merged.

* tt/64bit-bitmaps (Mon Feb 18 23:54:53 2008 -0500) 1 commit
 - Initial design for 64-bit bitmaps

	Some additional small bits of work on the infrastructure
----
URL's for the e2fsprogs repository:
        git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
        http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

