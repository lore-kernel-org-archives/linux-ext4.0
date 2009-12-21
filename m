From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Add module aliases for ext2 and ext3
Date: Mon, 21 Dec 2009 10:56:39 -0500
Message-ID: <20091221155639.GI4887@thunk.org>
References: <s5h6380lfr2.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Takashi Iwai <tiwai@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38746 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbZLUP4n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Dec 2009 10:56:43 -0500
Content-Disposition: inline
In-Reply-To: <s5h6380lfr2.wl%tiwai@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 21, 2009 at 12:37:37PM +0100, Takashi Iwai wrote:
> Add module aliases for ext2 and ext3 when CONFIG_EXT4_USE_FOR_EXT23 is
> set.  This makes the existing user-space stuff like mkinitrd working
> as is.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Thanks, added to the ext4 patch queue.

						- Ted
