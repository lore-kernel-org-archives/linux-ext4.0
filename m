From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: Fix ext4_writepages() in presence of truncate
Date: Sat, 17 Aug 2013 10:08:11 -0400
Message-ID: <20130817140811.GE30769@thunk.org>
References: <1375710744-29329-1-git-send-email-jack@suse.cz>
 <1375710744-29329-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44989 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab3HQOIS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Aug 2013 10:08:18 -0400
Content-Disposition: inline
In-Reply-To: <1375710744-29329-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 05, 2013 at 03:52:22PM +0200, Jan Kara wrote:
> Inode size can arbitrarily change while writeback is in progress. When
> ext4_writepages() has prepared a long extent for mapping and truncate
> then reduces i_size, mpage_map_and_submit_buffers() will always map just
> one buffer in a page instead of all of them due to lblk < blocks check.
> So we end up not using all blocks we've allocated (thus leaking them)
> and also delalloc accounting goes wrong manifesting as a warning like:
> 
> ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1
> with only 0 reserved data blocks
> 
> Note that the problem can happen only when blocksize < pagesize because
> otherwise we have only a single buffer in the page.
> 
> Fix the problem by removing the size check from the mapping loop. We
> have an extent allocated so we have to use it all before checking for
> i_size. We also rename add_page_bufs_to_extent() to
> mpage_process_page_bufs() and make that function submit the page for IO
> if all buffers (upto EOF) in it are mapped.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
