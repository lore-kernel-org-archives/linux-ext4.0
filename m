From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: 64-bit dblists
Date: Mon, 27 Oct 2008 16:59:10 -0400
Message-ID: <20081027205910.GD20992@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, "Jose R. Santos" <jrs@us.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYJ0U7M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Oct 2008 16:59:12 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

In my continuing quest to finish the 64-bit conversion of e2fsprogs, I
ran into this structure exported in ext2fs.h:

struct ext2_db_entry {
        ext2_ino_t      ino;
        blk_t   blk;
        int     blockcnt;
};

The "blk_t" is the problem here - we need a blk64_t.  A pointer to
this structure is passed to the user-provided directory block iterator
in ext2fs_dblist_iterate().

Assuming the goal is to preserve the ext2fs_dblist ABI, I can see two
ways of doing this:

1. Define ext2_db_entry2, ext2_dblist2, and ext2fs_dblist_*2() and do
the usual translation/conversion function business.

2. Use the magic number in the dblist to differentiate between old and
new-style dblists and keep the existing interfaces for functions that
only pass around pointers.  We'll also need ext2fs_dblist_iterate2()
and ext2fs_get_last2().

I find option #1 slightly less unpalatable than #2.  Does anyone have
an option #3?

-VAL
