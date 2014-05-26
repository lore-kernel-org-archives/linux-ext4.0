From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix zeroing of page during writeback
Date: Mon, 26 May 2014 12:37:59 -0400
Message-ID: <20140526163759.GL22284@thunk.org>
References: <1400771203-24260-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33187 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaEZQiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2014 12:38:06 -0400
Content-Disposition: inline
In-Reply-To: <1400771203-24260-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 22, 2014 at 05:06:43PM +0200, Jan Kara wrote:
> Tail of a page straddling inode size must be zeroed when being written
> out due to POSIX requirement that modifications of mmaped page beyond
> inode size must not be written to the file. ext4_bio_write_page() did
> this only for blocks fully beyond inode size but didn't properly zero
> blocks partially beyond inode size. Fix this.
> 
> The problem has been uncovered by mmap_11-4 test in openposix test suite
> (part of LTP).
> 
> Reported-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Fixes: 5a0dc7365c240
> Fixes: bd2d0210cf22f
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
