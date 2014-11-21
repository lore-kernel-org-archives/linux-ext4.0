From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
Date: Fri, 21 Nov 2014 16:42:45 -0500
Message-ID: <20141121214245.GG7112@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-2-git-send-email-tytso@mit.edu>
 <1416600528.24312.10@mail.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Chris Mason <clm@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44657 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbaKUVmr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2014 16:42:47 -0500
Content-Disposition: inline
In-Reply-To: <1416600528.24312.10@mail.thefacebook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Out of curiosity, why does btrfs_update_time() need to call
btrfs_root_readonly()?  Why can't it just depend on the
__mnt_want_write() call in touch_atime()?

Surely if there are times when it's not OK to write into a btrfs file
system and mnt_is_readonly() returns false, the VFS is going to get
very confused abyway.

If the btrfs_update_time() is not necessary, then we could drop
btrfs_update_time() and update_time() from the inode operations
entirely, and depend on the VFS-level code in update_time().

	      	     	    	      	   - Ted
