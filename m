From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/4] libext2fs: Fix return value in
 ext2fs_test_block_bitmap_range2()
Date: Thu, 28 Feb 2013 20:06:35 -0500
Message-ID: <20130301010635.GA18134@thunk.org>
References: <1361807708-15871-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50660 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3CABGv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Feb 2013 20:06:51 -0500
Content-Disposition: inline
In-Reply-To: <1361807708-15871-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2013 at 05:55:06AM -0000, Jan Kara wrote:
> We used return without a return value in
> ext2fs_test_block_bitmap_range2() despite the fuction returns int.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, this was fixed by commit 0d89e5ace which was submitted by
Philipp Thomas last month.  It's in the maint branch but not yet in a
released version of e2fsprogs yet.,

						- Ted
