From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext4: test the i_flags field of the right structure
Date: Sat, 14 Nov 2009 20:53:52 -0500
Message-ID: <20091115015352.GA4323@mit.edu>
References: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, cmm@us.ibm.com,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38463 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZKOBxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Nov 2009 20:53:55 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911022158190.4930@ask.diku.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 02, 2009 at 09:58:47PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Elsewhere, EXT4_EXTENTS_FL is combined with EXT4_I(inode)->i_flags, rather
> than inode->i_flags.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied to the ext4 patch queue, thanks.

							- Ted
