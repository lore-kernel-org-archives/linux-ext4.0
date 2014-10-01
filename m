From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: clarify inline data inode size error message
Date: Wed, 1 Oct 2014 08:38:01 -0400
Message-ID: <20141001123801.GC2903@thunk.org>
References: <20140927155515.GA2322@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaJAMiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 08:38:03 -0400
Content-Disposition: inline
In-Reply-To: <20140927155515.GA2322@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 27, 2014 at 11:55:15AM -0400, Eric Whitney wrote:
> The existing error message can be made more helpful by more clearly
> implying the attempt to make a file system with undersized inodes is
> failing and suggesting a corrective action.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

					- Ted
