From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: Fix error handling ext4_ind_get_blocks
Date: Sun, 15 Nov 2009 21:57:05 -0500
Message-ID: <20091116025705.GO4323@mit.edu>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <1256647729-29834-4-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59835 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbZKPC5E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 21:57:04 -0500
Content-Disposition: inline
In-Reply-To: <1256647729-29834-4-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 27, 2009 at 01:48:48PM +0100, Jan Kara wrote:
> When an error happened in ext4_splice_branch we failed to notice that
> in ext4_ind_get_blocks and mapped the buffer anyway. Fix the problem
> by checking for error properly.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Added to the ext4 patch queue, thanks.

						- Ted
