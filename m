From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: don't remove reserved inodes in ext4_unlink()
Date: Mon, 13 Oct 2014 12:21:00 -0400
Message-ID: <20141013162100.GF9738@thunk.org>
References: <20140212163825.GE14520@thunk.org>
 <1413103858-2258-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50176 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaJMQVH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 12:21:07 -0400
Content-Disposition: inline
In-Reply-To: <1413103858-2258-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 12, 2014 at 04:50:58PM +0800, Eryu Guan wrote:
> Corrupted ext4_dir_entry_2 struct on disk may have wrong inode number,
> when the inode number is 8 (EXT4_JOURNAL_INO) and the file is deleted,
> the journal inode is gone, and unmounting such a fs could trigger the
> following BUG_ON() in start_this_handle()....
> 

I believe the bug that this patch is trying to fix has been addressed
by this commit:

http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=bf8ad98e1bffa5ce178ef5e4ea803a86ac30f9e5

ext4: add ext4_iget_normal() which is to be used for dir tree lookups
If there is a corrupted file system which has directory entries that
point at reserved, metadata inodes, prohibit them from being used by
treating them the same way we treat Boot Loader inodes --- that is,
mark them to be bad inodes.  This prohibits them from being opened,
deleted, or modified via chmod, chown, utimes, etc.

In particular, this prevents a corrupted file system which has a
directory entry which points at the journal inode from being deleted
and its blocks released, after which point Much Hilarity Ensues.

Reported-by: Sami Liedes <sami.liedes@iki.fi>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org

					- Ted


