From: tytso@mit.edu
Subject: Re: [PATCH 1/3]ext4: Fix double-free of blocks with
 EXT4_IOC_MOVE_EXT
Date: Tue, 24 Nov 2009 10:30:25 -0500
Message-ID: <20091124153024.GJ2183@thunk.org>
References: <4B03A189.6000109@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42710 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363AbZKXPaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2009 10:30:24 -0500
Content-Disposition: inline
In-Reply-To: <4B03A189.6000109@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 18, 2009 at 04:26:01PM +0900, Akira Fujita wrote:
> ext4: Fix double-free of blocks with EXT4_IOC_MOVE_EXT
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> ext4_move_extent() calls ext4_discard_preallocations() to discard inode PAs
> of orig and donor inodes in its beginning.
> But the following case (1-4 steps) triggers the double-free of blocks,
> so move ext4_discard_preallocations() to the end of ext4_move_extents().

Thanks, applied to the ext4 patch queue.

					- Ted
