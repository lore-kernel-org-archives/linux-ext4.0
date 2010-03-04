From: tytso@mit.edu
Subject: Re: [PATCH] [RESEND] ext4: Release page references acquired in
 ext4_da_block_invalidatepages
Date: Wed, 3 Mar 2010 23:51:18 -0500
Message-ID: <20100304045118.GF3530@thunk.org>
References: <1267624447-19923-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55609 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab0CDEvU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Mar 2010 23:51:20 -0500
Content-Disposition: inline
In-Reply-To: <1267624447-19923-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 03, 2010 at 02:54:07PM +0100, Jan Kara wrote:
> We forget to release page references we acquire in
> ext4_da_block_invalidatepages.  Luckily, this function gets called only if we
> are not able to allocate blocks for delay-allocated data so that function
> should better never be called.
> 
> Also cleanup handling of index variable.
> 
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Added to the ext4 patch queue, thanks.

				- Ted
