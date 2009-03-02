From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH-e2fsprogs] Allow clearing flex_bg if only one group per
	flex
Date: Mon, 2 Mar 2009 07:39:08 -0500
Message-ID: <20090302123908.GJ6973@mit.edu>
References: <1235982524-7673-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47194 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZCBMjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Mar 2009 07:39:15 -0500
Content-Disposition: inline
In-Reply-To: <1235982524-7673-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 02, 2009 at 04:28:44PM +0800, Peng Tao wrote:
> This can be caused by tune2fs -O flex_bg. And clearing flex_bg on such
> partitions is harmless.

It's actually not necessarily harmless; e2fsck could have already
assigned new bitmap and inode tables outside of the block group.  If
you want to enable this, you need to actually check to make sure all
of the block/inode bitmap blocks and inode tables are within their own
block group before allowing flex_bg to be cleared.

						- Ted
