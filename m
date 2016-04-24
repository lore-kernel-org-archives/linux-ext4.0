From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: Remove EXT4_STATE_ORDERED_MODE
Date: Sat, 23 Apr 2016 23:48:23 -0400
Message-ID: <20160424034822.GH20980@thunk.org>
References: <1459354767-8693-1-git-send-email-jack@suse.cz>
 <1459354767-8693-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Weller.Huang@cn.bosch.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32800 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbcDXDs0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Apr 2016 23:48:26 -0400
Content-Disposition: inline
In-Reply-To: <1459354767-8693-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 30, 2016 at 06:19:25PM +0200, Jan Kara wrote:
> This flag is just duplicating what ext4_should_order_data() tells you
> and is used in a single place. Furthermore it doesn't reflect changes to
> inode data journalling flag so it may be possibly misleading. Just
> remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
