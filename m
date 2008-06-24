From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3: validate directory entry data before use
Date: Tue, 24 Jun 2008 00:36:06 -0600
Message-ID: <20080624063606.GE6239@webber.adilger.int>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
 <1214013261-32428-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41112 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYFXGgL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2008 02:36:11 -0400
In-reply-to: <1214013261-32428-1-git-send-email-duaneg@dghda.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 21, 2008  02:54 +0100, Duane Griffin wrote:
> Various places in fs/ext3/namei.c use ext3_next_entry to loop over
> directory entries, but not all of them verify that entries are valid before
> attempting to move to the next one. In the case where rec_len == 0 this
> causes an infinite loop.
> 
> Introduce a new version of ext3_next_entry that checks the validity of the
> entry before using its data to find the next one. Rename the original
> function to __ext3_next_entry and use it in places where we already know
> the data is valid.
>
> Note that the changes to empty_dir follow the original code in reporting
> the directory as empty in the presence of errors.
> 
> This patch fixes the first case (image hdb.25.softlockup.gz) reported in
> http://bugzilla.kernel.org/show_bug.cgi?id=10882.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> --
> 
> Please note that I've only properly tested the originally reported failure
> case (i.e. the changes to ext3_dx_find_entry).
> 
> Reviewers may want to pay particular attention to the changes to do_split,
> make_indexed_dir and empty_dir. I've tried to follow the original code's
> error handling conventions, as noted above for empty_dir, but I'm not sure
> this is the best way to do things.

Just as a note, and not to detract from the validity of this patch -
in the ext2 page-based directory code is somewhat more efficient in this
area.  It checks each page a single time when it is first read from disk,
marks the page as checked, and then never has to check the page again.

This wasn't implemented for ext3 because it never changed from buffer-
based directories to page-based directories due to the dependence on
buffer heads for the journaling code.

It would be possible to implement this for ext3/ext4 readdir/lookup by
replacing use of ext3_bread() with a new ext3_bread_dir() - a copy of
ext3_bread() that validates the buffer if it actually needs ll_rw_block()
to read the buffer from disk.

I also note in ext3_readdir() for non-indexed directories that the readahead
doesn't check for !buffer_uptodate(bh) before forcing a read of the next
block.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

