From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/18] e2fsck: write dir blocks after new inode when
 reconstructing root/lost+found
Date: Sat, 26 Jul 2014 17:18:46 -0400
Message-ID: <20140726211846.GS6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003441.28334.28347.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58793 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbaGZVSs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jul 2014 17:18:48 -0400
Content-Disposition: inline
In-Reply-To: <20140726003441.28334.28347.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:41PM -0700, Darrick J. Wong wrote:
> If we trash the root directory block, e2fsck will find inode 11 (the
> old lost+found) and try to attach it to l+f.  The lost+found checker
> also fails to find l+f and tries to add one to the root dir.  The root
> dir is not found but is recreated with incorrect checksums, so linking
> in the l+f dir fails and the l+f '..' entry isn't set.  Since both
> dirs now fail checksum verification, they're both referred to rehash
> to have that fixed, but because l+f doesn't have a '..' entry, rehash
> crashes because l+f has < 2 entries.
> 
> On a checksumming filesystem, the routines in e2fsck that recreate
> /lost+found and / must write the new directory block *after* the inode
> has been written to disk because the checksum depends on i_generation.
> Add a regression test while we're at it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
