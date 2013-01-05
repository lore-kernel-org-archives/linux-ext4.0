From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/3 V2] ext2fsprogs: Symlink support
Date: Fri, 4 Jan 2013 19:15:21 -0500
Message-ID: <20130105001521.GD6501@thunk.org>
References: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, sgw@linux.intel.com,
	darrick.wong@oracle.com
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41791 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3AEAPa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2013 19:15:30 -0500
Content-Disposition: inline
In-Reply-To: <1357329660-28639-1-git-send-email-dvhart@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 04, 2013 at 12:00:57PM -0800, Darren Hart wrote:
> The following series adds symlink support the libext2fs and adds the command to
> debugfs. Basic testing demonstrates functional duplication of a small test
> directory including fastlinks and slowlinks in both the root and a single
> subdirectory.

One thing I'd really appreciate is if you could write a regression
test for this new code.  You can use tests/d_loaddump and
tests/f_dup4/script as a model; I'd suggest calling it d_symlink, and
it would be good if it created a short symlink and a long symlink, and
that the script verified that you get the expected output when you
stat the small and long symlinks using debugfs.  Then run e2fsck on
the file system and make sure the file system is consistent.

Note the use of the debugfs commands:

	set_current_time 200704102100
	set_super_value lastcheck 0
	set_super_value hash_seed null
	set_super_value mkfs_time 0

and the environment variable: 

	E2FSCK_TIME=200704102100

in f_dup4's script.  These are used to control various variable
(random or time-specific) values such that so that you can use a
simple comparison of the output of programs such as debugfs, mke2fs,
and dumpe2fs using "diff".

Thanks again!!

						- Ted

P.S.  Actually, while you're at it, if you could also have the script
create some block and character device files using the debugfs mknod
command, and perhaps call the test d_create_spec_files instead of
d_symlink, that would be great!   (Since I don't think those functions
currently any good test coverage.) 

