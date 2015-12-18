From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 0/3] ext4 crypto: back up encrypted files
Date: Thu, 17 Dec 2015 19:49:35 -0500
Message-ID: <20151218004935.GA17115@thunk.org>
References: <1449759879-2166-1-git-send-email-tytso@mit.edu>
 <20151216151010.GB16918@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36831 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbbLRAti (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Dec 2015 19:49:38 -0500
Content-Disposition: inline
In-Reply-To: <20151216151010.GB16918@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 16, 2015 at 04:10:10PM +0100, Jan Kara wrote:
> 
> Umm, I don't quite follow. O_DIRECT reads will actually read final file
> block in full even if i_size is somewhere in the middle of it. We then
> report only data upto i_size as transferred but that's not really
> important for you.

I had tried this approach first but it appeared that the data was
getting zero'ed between i_size and the end of the block.  It turns out
it was a bug in my test program, sigh.

I agree about the locking issues.  It isn't so much of an issue since
without the encryption key, you can't modify the file, so this
prevents most of the nasty races.  Of course, it could be the case
that user A (say, root) doesn't have access to the key, but user B
(say the user account) does have access.  So dropping the shadow inode
is the better way to go.

Thanks!!

						- Ted
