From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/18] e2fsck: insert a missing dirent tail for checksums
 if possible
Date: Sat, 26 Jul 2014 17:13:56 -0400
Message-ID: <20140726211356.GR6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003435.28334.36415.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58780 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbaGZVN6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 17:13:58 -0400
Content-Disposition: inline
In-Reply-To: <20140726003435.28334.36415.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:35PM -0700, Darrick J. Wong wrote:
> If e2fsck is writing a block of directory entries to disk, it should
> adjust the dirents to add the dirent tail if one is missing.  It's not
> a big deal if there's no space to do this since rehash (pass 3A) will
> reconstruct directories for us.  However, we may as well avoid
> unnecessary work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
