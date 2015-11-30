From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] e2fsck: do not read EA header beyond the end of an
 inode
Date: Mon, 30 Nov 2015 12:06:52 -0500
Message-ID: <20151130170652.GC4316@thunk.org>
References: <1448569394-27134-1-git-send-email-artemiyv@acm.org>
 <1448571594-32225-1-git-send-email-artemiyv@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Artemiy Volkov <artemiyv@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57913 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbbK3RGy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 12:06:54 -0500
Content-Disposition: inline
In-Reply-To: <1448571594-32225-1-git-send-email-artemiyv@acm.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 26, 2015 at 08:59:54PM +0000, Artemiy Volkov wrote:
> In check_inode_extra_space(), if we attempt to read an EA header at
> the end of the extra space, in a corrupted filesystem it may result in
> a read beyond the bounds of the inode. Add a check to prevent this.
> 
> Reproduced by running ./test_one --valgrind f_write_ea_toobig_extra_isize.
> 
> Signed-off-by: Artemiy Volkov <artemiyv@acm.org>

Applied, thanks.

					- Ted
