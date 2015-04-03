From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Make fsync to sync parent dir in no-journal for
 real this time
Date: Thu, 2 Apr 2015 23:45:38 -0400
Message-ID: <20150403034538.GD10991@thunk.org>
References: <1424697396-17248-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Frank Mayhar <fmayhar@google.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48505 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbbDCDpm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 23:45:42 -0400
Content-Disposition: inline
In-Reply-To: <1424697396-17248-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 23, 2015 at 02:16:36PM +0100, Lukas Czerner wrote:
> Previously commit 14ece1028b3ed53ffec1b1213ffc6acaf79ad77c added a
> support for for syncing parent directory of newly created inodes to make
> sure that the inode is not lost after a power failure in no-journal
> mode.
> 
> However this does not work in majority of cases, namely:
>  - if the directory has inline data
>  - if the directory is already indexed
>  - if the directory already has at least one block and:
> 	- the new entry fits into it
> 	- or we've successfully converted it to indexed
> 
> So in those cases we might lose the inode entirely even after fsync in
> the no-journal mode. This also includes ext2 default mode obviously.
> 
> I've noticed this while running xfstest generic/321 and even though the
> test should fail (we need to run fsck after a crash in no-journal mode)
> I could not find a newly created entries even when if it was fsynced
> before.
> 
> Fix this by adjusting the ext4_add_entry() successful exit paths to set
> the inode EXT4_STATE_NEWENTRY so that fsync has the chance to fsync the
> parent directory as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Frank Mayhar <fmayhar@google.com>

Thanks, applied.

						- Ted
