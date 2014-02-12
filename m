From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't remove reserved inodes in ext4_unlink()
Date: Wed, 12 Feb 2014 11:38:25 -0500
Message-ID: <20140212163825.GE14520@thunk.org>
References: <1390633097-16194-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57109 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbaBLQib (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 11:38:31 -0500
Content-Disposition: inline
In-Reply-To: <1390633097-16194-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 25, 2014 at 02:58:17PM +0800, Eryu Guan wrote:
> Corrupted ext4_dir_entry_2 struct on disk may have wrong inode number,
> when the inode number is 8 (EXT4_JOURNAL_INO) and the file is deleted,
> the journal inode is gone, and unmounting such a fs could trigger the
> following BUG_ON() in start_this_handle().....

This patch is mostly good, but you need to exempt the root inode.
Otherwise, the following program, which would normally give the error
"unlink: Is a directory", will mark the file system as containing an
error, and so it could allow an unprivileged user to remount the file
system read-only, or force the system to panic and reboot.

#include <unistd.h>

int main(int argc, char **argv)
{

	if (unlink("/") < 0)
		perror("unlink");
	return 0;
}

Cheers,

					- Ted
