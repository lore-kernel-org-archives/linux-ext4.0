From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs support for BLKDISCARD
Date: Sun, 15 Nov 2009 23:54:28 -0500
Message-ID: <20091116045428.GA17961@mit.edu>
References: <4ACD0CDD.2070806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50402 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZKPEya (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Nov 2009 23:54:30 -0500
Content-Disposition: inline
In-Reply-To: <4ACD0CDD.2070806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 07, 2009 at 04:49:17PM -0500, Eric Sandeen wrote:
> Try calling the BLKDISCARD ioctl at mkfs time to pre-discard all blocks
> on an ssd, or a thinly-provisioned storage device.
>
> No real error checking; if it fails, it fails, and that's ok - it's
> just an optimization.  Also, it cannot work in conjunction with
> the undo io manager, for obvious reasons.
>
> Optionally disabled with a "-K" (mnemonic: Keep) option.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Added to e2fsprogs's maint branch, thanks.

						- Ted
