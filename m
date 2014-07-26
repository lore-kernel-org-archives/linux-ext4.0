From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/18] dumpe2fs: add switch to disable checksum
 verification
Date: Sat, 26 Jul 2014 16:58:08 -0400
Message-ID: <20140726205808.GP6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003416.28334.11698.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58747 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaGZU6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 16:58:09 -0400
Content-Disposition: inline
In-Reply-To: <20140726003416.28334.11698.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:16PM -0700, Darrick J. Wong wrote:
> Add a -n switch to turn off checksum verification.

Instead of adding a -n flag, I wonder if the better thing to do is if
the various functions that might return a checksum error error out, we
print a warning message indicating checksum failure occured, and then
retry with EXT2_FLAG_IGNORE_CSUM_ERRORS.  That is, either retry the
ext2fs_open with the IGNORE_CSUM_ERRORS, or if the file system is
already open, or in EXT2_FLAG_IGNORE_CSUM_ERRORS into fs->flags and
then retry the ext2fs_read_bitmaps() or whatever.

What do you think?

					- Ted
