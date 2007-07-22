From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] fix test in ext2fs_check_desc() for inode table within block group
Date: Sun, 22 Jul 2007 16:01:49 -0400
Message-ID: <20070722200149.GC16658@thunk.org>
References: <46A12E22.3030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54856 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761132AbXGVUBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2007 16:01:52 -0400
Content-Disposition: inline
In-Reply-To: <46A12E22.3030102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2007 at 04:50:26PM -0500, Eric Sandeen wrote:
> The test in ext2fs_check_desc() is off by one; if the inode table
> goes all the way to the last block of the block group, it will 
> falsely assert that it has extended past it.  The last block
> of a range is start + len -1, not start + len.

Thanks, committed into git (combined with the test case) and updated
commit log to include the Red Hat Bugzilla number.

						- Ted
