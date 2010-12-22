From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/15] libext2fs: fix possible memory leak in
 write_journal_inode()
Date: Wed, 22 Dec 2010 10:43:19 -0500
Message-ID: <20101222154319.GG5700@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-15-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0LVPnV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Dec 2010 10:43:21 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-15-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:16PM +0900, Namhyung Kim wrote:
> ext2fs_zero_block2() allocates static buffer if needed so it
> should be freed at last (call it again with 0 args).
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, applied.

						- Ted
